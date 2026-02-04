//
//  ThermalHeatManager.swift
//  AiAiOh
//
//  Manages heat sources from user interactions for thermal background effect
//  Optimized for slow, gradual, seamless heat response with natural cooling
//

import SwiftUI
import Observation

// MARK: - Heat Source Model

/// Represents a single heat source in the thermal system
/// Each heat source has a position, intensity, and lifecycle
struct HeatSource: Identifiable {
    let id = UUID()
    
    /// Position in normalized coordinates (0-1 range for both x and y)
    var position: CGPoint
    
    /// Current heat intensity (0-1, where 0 is cold and 1 is maximum heat)
    var intensity: Float
    
    /// Target intensity that the current intensity smoothly ramps toward
    var targetIntensity: Float
    
    /// Radius of heat spread (how far the heat extends from center)
    var radius: Float
    
    /// When this heat source was created (used for age calculation)
    var creationTime: Date
    
    /// Whether this heat source came from scrolling (affects behavior)
    var isScrollHeat: Bool
    
    /// Age in seconds since creation
    var age: Float {
        Float(Date().timeIntervalSince(creationTime))
    }
}

// MARK: - Metal-Compatible Structures

/// Heat source data structure that matches the Metal shader layout
/// Must stay in sync with the HeatSource struct in ThermalShader.metal
struct MetalHeatSource {
    var position: SIMD2<Float>  // Normalized x,y position
    var intensity: Float         // Heat intensity (0-1)
    var radius: Float            // Spread radius
    var age: Float               // Age in seconds
    
    /// Create from raw values
    init(position: SIMD2<Float>, intensity: Float, radius: Float, age: Float) {
        self.position = position
        self.intensity = intensity
        self.radius = radius
        self.age = age
    }
    
    /// Convert from high-level HeatSource model
    init(from source: HeatSource) {
        self.position = SIMD2<Float>(Float(source.position.x), Float(source.position.y))
        self.intensity = source.intensity
        self.radius = source.radius
        self.age = source.age
    }
}

/// Global shader parameters passed to Metal each frame
/// Must stay in sync with ThermalUniforms in ThermalShader.metal
struct ThermalUniforms {
    var time: Float                  // Current time for animation
    var resolution: SIMD2<Float>     // Screen resolution
    var heatSourceCount: Int32       // Number of active heat sources
    var baseTemperature: Float       // Minimum background temperature
    var maxTemperature: Float        // Maximum possible temperature
    var _padding: Float = 0          // Padding for 16-byte alignment
}

// MARK: - Thermal Heat Manager

/// Observable manager that tracks and updates all heat sources in the thermal system
/// Handles creation, decay, merging, and removal of heat sources based on user interaction
@Observable
@MainActor
final class ThermalHeatManager {
    
    // MARK: - Configuration Properties
    
    /// Base "cold" temperature when no heat is present (affects blue tint)
    /// Lower values = colder, darker background
    var baseTemperature: Float = 0.06
    
    /// Maximum heat level that can be achieved
    /// Higher values = brighter, more intense heat colors
    var maxTemperature: Float = 0.82
    
    /// How quickly heat decays over time (lower = slower cooling)
    /// This creates the gradual fade-out effect
    var decayRate: Float = 0.08
    
    /// How quickly intensity ramps up to target (lower = slower buildup)
    /// This creates smooth, gradual heat increases
    var rampUpRate: Float = 0.12
    
    /// Base radius for tap-generated heat sources
    /// Controls how large a tap's heat area appears
    var tapRadius: Float = 0.5
    
    /// Base radius for scroll-generated heat sources
    /// Typically larger than tap radius
    var scrollRadius: Float = 0.7
    
    /// Maximum number of simultaneous heat sources allowed
    /// Older/weaker sources are removed when limit is reached
    var maxHeatSources: Int = 24
    
    /// Heat intensity created by a single tap
    var tapIntensity: Float = 0.28
    
    /// Heat intensity added per scroll update event
    var scrollIntensityPerUpdate: Float = 0.012
    
    /// How much heat sources expand as they cool
    /// Creates a spreading effect as heat dissipates
    var expansionRate: Float = 0.015
    
    /// Minimum intensity before a heat source is removed
    /// Prevents very faint sources from lingering
    var minimumIntensity: Float = 0.003
    
    /// Distance threshold for merging nearby heat sources
    /// When sources are closer than this, they combine
    var mergeThreshold: Float = 0.25
    
    // MARK: - State Properties
    
    /// Array of all currently active heat sources
    private(set) var heatSources: [HeatSource] = []
    
    /// Time when the manager was created (for animation timing)
    private(set) var startTime: Date = Date()
    
    /// Current elapsed time in seconds (used for shader animation)
    var currentTime: Float {
        Float(Date().timeIntervalSince(startTime))
    }
    
    // MARK: - Public Heat Addition Methods
    
    /// Add heat from a tap at the given screen position
    /// Creates a focused heat spot that gradually fades
    /// - Parameters:
    ///   - position: Touch position in screen coordinates
    ///   - size: Size of the container view (for normalization)
    func addTapHeat(at position: CGPoint, in size: CGSize) {
        let normalizedPosition = normalizePosition(position, in: size)
        
        // Check if there's already a heat source nearby
        if let existingIndex = findNearbySource(at: normalizedPosition, threshold: mergeThreshold) {
            // Boost the existing source instead of creating a new one
            heatSources[existingIndex].targetIntensity = min(
                heatSources[existingIndex].targetIntensity + tapIntensity * 0.4,
                0.65  // Cap to prevent over-saturation
            )
            
            // Slightly move the source toward the new tap position
            heatSources[existingIndex].position = CGPoint(
                x: heatSources[existingIndex].position.x * 0.85 + normalizedPosition.x * 0.15,
                y: heatSources[existingIndex].position.y * 0.85 + normalizedPosition.y * 0.15
            )
            return
        }
        
        // Create new heat source
        let source = HeatSource(
            position: normalizedPosition,
            intensity: 0.0,  // Start at zero, will ramp up smoothly
            targetIntensity: tapIntensity,
            radius: tapRadius,
            creationTime: Date(),
            isScrollHeat: false
        )
        
        addHeatSource(source)
    }
    
    /// Add heat from scrolling - call repeatedly during scroll gestures
    /// Creates trailing heat that follows scroll direction
    /// - Parameters:
    ///   - position: Touch position in screen coordinates
    ///   - size: Size of the container view (for normalization)
    ///   - velocity: Scroll velocity (faster = more heat)
    func addScrollHeat(at position: CGPoint, in size: CGSize, velocity: CGFloat = 1.0) {
        let normalizedPosition = normalizePosition(position, in: size)
        
        // Scale heat intensity based on scroll speed (capped)
        let velocityFactor = min(Float(abs(velocity)) / 400.0, 1.5)
        
        // Look for existing scroll heat source nearby
        if let existingIndex = findNearbyScrollSource(at: normalizedPosition) {
            // Boost existing scroll heat
            let intensityBoost = scrollIntensityPerUpdate * velocityFactor
            heatSources[existingIndex].targetIntensity = min(
                heatSources[existingIndex].targetIntensity + intensityBoost,
                0.55  // Cap scroll heat intensity
            )
            
            // Smoothly track the scroll position
            heatSources[existingIndex].position = CGPoint(
                x: heatSources[existingIndex].position.x * 0.8 + normalizedPosition.x * 0.2,
                y: heatSources[existingIndex].position.y * 0.8 + normalizedPosition.y * 0.2
            )
        } else {
            // Create new scroll heat source
            let source = HeatSource(
                position: normalizedPosition,
                intensity: 0.0,
                targetIntensity: scrollIntensityPerUpdate * velocityFactor * 2.5,
                radius: scrollRadius,
                creationTime: Date(),
                isScrollHeat: true
            )
            addHeatSource(source)
        }
    }
    
    /// Add heat from a drag gesture
    /// Creates continuous heat trail following finger movement
    /// - Parameters:
    ///   - position: Touch position in screen coordinates
    ///   - size: Size of the container view (for normalization)
    func addDragHeat(at position: CGPoint, in size: CGSize) {
        let normalizedPosition = normalizePosition(position, in: size)
        
        // Check for nearby source to boost
        if let existingIndex = findNearbySource(at: normalizedPosition, threshold: mergeThreshold * 0.8) {
            // Boost existing drag heat
            heatSources[existingIndex].targetIntensity = min(
                heatSources[existingIndex].targetIntensity + 0.06,
                0.6
            )
            
            // Smoothly follow the drag
            heatSources[existingIndex].position = CGPoint(
                x: heatSources[existingIndex].position.x * 0.75 + normalizedPosition.x * 0.25,
                y: heatSources[existingIndex].position.y * 0.75 + normalizedPosition.y * 0.25
            )
            return
        }
        
        // Create new drag heat source
        let source = HeatSource(
            position: normalizedPosition,
            intensity: 0.0,
            targetIntensity: tapIntensity * 0.45,
            radius: tapRadius * 0.85,
            creationTime: Date(),
            isScrollHeat: false
        )
        
        addHeatSource(source)
    }
    
    /// Update all heat sources - call this every frame (60 FPS)
    /// Handles intensity ramping, decay, expansion, and removal
    /// - Parameter deltaTime: Time elapsed since last frame (in seconds)
    func update(deltaTime: Float) {
        var indicesToRemove: [Int] = []
        
        // Update each heat source
        for i in heatSources.indices {
            let intensityDiff = heatSources[i].targetIntensity - heatSources[i].intensity
            
            if intensityDiff > 0.001 {
                // Ramping up: gradually increase toward target
                heatSources[i].intensity += intensityDiff * rampUpRate * deltaTime * 60.0
            } else {
                // Cooling down: decay the target, then intensity follows
                heatSources[i].targetIntensity -= decayRate * deltaTime
                heatSources[i].targetIntensity = max(heatSources[i].targetIntensity, 0)
                
                // Intensity lags behind target for smooth cooldown
                heatSources[i].intensity += (heatSources[i].targetIntensity - heatSources[i].intensity) * 0.1
            }
            
            // Gradual radius expansion as heat spreads and dissipates
            if heatSources[i].intensity > 0.03 {
                heatSources[i].radius += deltaTime * expansionRate
                heatSources[i].radius = min(heatSources[i].radius, 1.0)
            }
            
            // Mark fully cooled sources for removal
            if heatSources[i].intensity <= minimumIntensity &&
               heatSources[i].targetIntensity <= minimumIntensity {
                indicesToRemove.append(i)
            }
        }
        
        // Remove dead sources (in reverse to preserve indices)
        for index in indicesToRemove.reversed() {
            heatSources.remove(at: index)
        }
        
        // Periodically merge overlapping sources for smoother blending
        mergeCloseSources()
    }
    
    /// Convert heat sources to Metal-compatible format
    /// - Returns: Array of heat sources formatted for GPU shader
    func metalHeatSources() -> [MetalHeatSource] {
        heatSources.prefix(maxHeatSources).map { MetalHeatSource(from: $0) }
    }
    
    /// Get shader uniforms for the current frame
    /// - Parameter size: Current screen/view size
    /// - Returns: Uniform data for Metal shader
    func uniforms(for size: CGSize) -> ThermalUniforms {
        ThermalUniforms(
            time: currentTime,
            resolution: SIMD2<Float>(Float(size.width), Float(size.height)),
            heatSourceCount: Int32(min(heatSources.count, maxHeatSources)),
            baseTemperature: baseTemperature,
            maxTemperature: maxTemperature
        )
    }
    
    /// Remove all heat sources (reset to cold state)
    func reset() {
        heatSources.removeAll()
    }
    
    // MARK: - Private Helper Methods
    
    /// Convert screen coordinates to normalized 0-1 range
    private func normalizePosition(_ position: CGPoint, in size: CGSize) -> CGPoint {
        CGPoint(
            x: position.x / size.width,
            y: position.y / size.height
        )
    }
    
    /// Add a heat source, removing the weakest if at capacity
    private func addHeatSource(_ source: HeatSource) {
        if heatSources.count >= maxHeatSources {
            // Remove the weakest (lowest intensity) source
            if let minIndex = heatSources.enumerated()
                .min(by: { $0.element.intensity < $1.element.intensity })?.offset {
                heatSources.remove(at: minIndex)
            }
        }
        
        heatSources.append(source)
    }
    
    /// Find a nearby heat source within threshold distance
    private func findNearbySource(at position: CGPoint, threshold: Float) -> Int? {
        let thresholdCG = CGFloat(threshold)
        return heatSources.firstIndex { source in
            let dx = abs(source.position.x - position.x)
            let dy = abs(source.position.y - position.y)
            return dx < thresholdCG && dy < thresholdCG
        }
    }
    
    /// Find a nearby scroll-specific heat source
    private func findNearbyScrollSource(at position: CGPoint) -> Int? {
        let threshold: CGFloat = 0.3
        
        return heatSources.firstIndex { source in
            source.isScrollHeat &&
            abs(source.position.x - position.x) < threshold &&
            abs(source.position.y - position.y) < threshold
        }
    }
    
    /// Merge heat sources that are very close together
    /// This prevents clustering and creates smoother heat blobs
    private func mergeCloseSources() {
        // Only run occasionally to avoid performance hit
        guard Int.random(in: 0..<30) == 0 else { return }
        
        var i = 0
        while i < heatSources.count {
            var j = i + 1
            while j < heatSources.count {
                let dx = abs(heatSources[i].position.x - heatSources[j].position.x)
                let dy = abs(heatSources[i].position.y - heatSources[j].position.y)
                
                // If very close, merge them
                if dx < 0.1 && dy < 0.1 {
                    // Combine intensities (with slight dampening)
                    heatSources[i].intensity = min(
                        heatSources[i].intensity + heatSources[j].intensity * 0.5,
                        0.7
                    )
                    heatSources[i].targetIntensity = min(
                        heatSources[i].targetIntensity + heatSources[j].targetIntensity * 0.5,
                        0.7
                    )
                    
                    // Average positions
                    heatSources[i].position = CGPoint(
                        x: (heatSources[i].position.x + heatSources[j].position.x) / 2,
                        y: (heatSources[i].position.y + heatSources[j].position.y) / 2
                    )
                    
                    // Slightly expand radius
                    heatSources[i].radius = min(heatSources[i].radius + 0.05, 1.0)
                    
                    // Remove the merged source
                    heatSources.remove(at: j)
                } else {
                    j += 1
                }
            }
            i += 1
        }
    }
}
