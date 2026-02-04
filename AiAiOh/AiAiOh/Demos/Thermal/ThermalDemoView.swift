//
//  ThermalDemoView.swift
//  AiAiOh
//
//  Pure thermal background visualization
//  Touch anywhere to generate beautiful heat patterns
//

import SwiftUI

// MARK: - Thermal Demo View

struct ThermalDemoView: View {
    
    // MARK: - State Properties
    
    /// Manages all heat sources and their lifecycle
    @State private var thermalManager = ThermalHeatManager()
    
    /// Tracks the size of the view container for normalizing touch positions
    @State private var containerSize: CGSize = .zero
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background layer: renders the thermal heat effect using Metal
            ThermalBackgroundView(heatManager: thermalManager)
                .ignoresSafeArea()
        }
        // Track the container size for proper heat position normalization
        .background(
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        containerSize = geometry.size
                    }
                    .onChange(of: geometry.size) { _, newSize in
                        containerSize = newSize
                    }
            }
        )
        // Capture all touch interactions with high sensitivity
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { value in
                    handleThermalInteraction(at: value.location, translation: value.translation)
                }
        )
    }
    
    // MARK: - Interaction Handlers
    
    /// Handles thermal heat generation based on user touch input
    /// Enhanced sensitivity for more responsive heat generation
    /// - Parameters:
    ///   - location: The touch position in screen coordinates
    ///   - translation: The movement delta from initial touch position
    private func handleThermalInteraction(at location: CGPoint, translation: CGSize) {
        // Calculate how far the finger has moved
        let movementMagnitude = sqrt(
            pow(translation.width, 2) + pow(translation.height, 2)
        )
        
        // Increased sensitivity - smaller threshold for tap detection
        if movementMagnitude < 5 {
            // Small movement = tap (creates focused heat spot)
            thermalManager.addTapHeat(at: location, in: containerSize)
            
            // Add extra heat burst for more visible effect
            let burstRadius: CGFloat = 30
            for i in 0..<6 {
                let angle = CGFloat(i) * (.pi / 3)
                let distance = burstRadius * 0.5
                let burstPoint = CGPoint(
                    x: location.x + cos(angle) * distance,
                    y: location.y + sin(angle) * distance
                )
                thermalManager.addTapHeat(at: burstPoint, in: containerSize)
            }
        } else {
            // Larger movement = drag (creates trailing heat)
            thermalManager.addDragHeat(at: location, in: containerSize)
            
            // Add extra drag heat points for more responsive trail
            // Creates a thicker, more visible heat trail
            let perpAngle = atan2(translation.height, translation.width) + .pi / 2
            let offset: CGFloat = 15
            
            let point1 = CGPoint(
                x: location.x + cos(perpAngle) * offset,
                y: location.y + sin(perpAngle) * offset
            )
            let point2 = CGPoint(
                x: location.x - cos(perpAngle) * offset,
                y: location.y - sin(perpAngle) * offset
            )
            
            thermalManager.addDragHeat(at: point1, in: containerSize)
            thermalManager.addDragHeat(at: point2, in: containerSize)
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        ThermalDemoView()
    }
}
