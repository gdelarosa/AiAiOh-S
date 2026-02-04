//
//  ThermalBackgroundView.swift
//  AiAiOh
//
//  SwiftUI view that displays the thermal heat effect background using Metal
//

import SwiftUI
import MetalKit

// MARK: - Thermal Background View

/// Main view that displays the thermal background effect
/// This view wraps the Metal renderer in a SwiftUI-friendly interface
struct ThermalBackgroundView: View {
    /// The heat manager that tracks all heat sources
    let heatManager: ThermalHeatManager
    
    var body: some View {
        GeometryReader { geometry in
            ThermalMetalView(heatManager: heatManager)
                .ignoresSafeArea()
        }
    }
}

// MARK: - Metal View Representable

/// UIViewRepresentable wrapper for MTKView (Metal rendering view)
/// This bridges UIKit's Metal view to SwiftUI
struct ThermalMetalView: UIViewRepresentable {
    let heatManager: ThermalHeatManager
    
    /// Creates the underlying MTKView with Metal configuration
    func makeUIView(context: Context) -> MTKView {
        let mtkView = MTKView()
        
        // Configure Metal device (GPU)
        mtkView.device = MTLCreateSystemDefaultDevice()
        
        // Set pixel format for color rendering
        mtkView.colorPixelFormat = .bgra8Unorm
        
        // Optimize for display-only rendering (no reading back from GPU)
        mtkView.framebufferOnly = true
        
        // Target 60 FPS for smooth animation
        mtkView.preferredFramesPerSecond = 60
        
        // Disable manual draw triggers (we want continuous rendering)
        mtkView.enableSetNeedsDisplay = false
        mtkView.isPaused = false
        
        // Set clear color to deep thermal blue/black
        mtkView.clearColor = MTLClearColor(red: 0.02, green: 0.02, blue: 0.05, alpha: 1.0)
        
        // Make the view opaque for better performance
        mtkView.isOpaque = true
        
        // Set the delegate to handle rendering
        mtkView.delegate = context.coordinator
        
        return mtkView
    }
    
    /// Called when SwiftUI updates the view (no-op for this view)
    func updateUIView(_ uiView: MTKView, context: Context) {
        // The view updates automatically via the delegate
    }
    
    /// Creates the coordinator that handles Metal rendering
    func makeCoordinator() -> ThermalMTKViewCoordinator {
        let renderer = ThermalMetalRenderer()
        return ThermalMTKViewCoordinator(renderer: renderer, heatManager: heatManager)
    }
}

// MARK: - View Extension

extension View {
    /// Applies thermal background effect to any view
    /// - Parameter manager: The heat manager to use for tracking heat sources
    /// - Returns: Modified view with thermal background
    func thermalBackground(manager: ThermalHeatManager) -> some View {
        self.background(
            ThermalBackgroundView(heatManager: manager)
        )
    }
}
