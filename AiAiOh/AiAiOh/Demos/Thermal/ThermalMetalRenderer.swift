//
//  ThermalMetalRenderer.swift
//  AiAiOh
//
//  Metal renderer for thermal background effect
//  Handles GPU-accelerated rendering of heat sources using custom shaders
//

import Metal
import MetalKit
import QuartzCore

/// Main renderer class that manages Metal rendering pipeline for thermal effects
@MainActor
final class ThermalMetalRenderer: NSObject {
    
    // MARK: - Metal Objects
    
    /// The GPU device used for rendering
    private let device: MTLDevice
    
    /// Command queue for submitting GPU work
    private let commandQueue: MTLCommandQueue
    
    /// Compiled shader pipeline state
    private var pipelineState: MTLRenderPipelineState?
    
    // MARK: - GPU Buffers
    
    /// Buffer containing uniform data (time, resolution, etc.)
    private var uniformBuffer: MTLBuffer?
    
    /// Buffer containing array of heat source data
    private var heatSourceBuffer: MTLBuffer?
    
    // MARK: - Configuration
    
    /// Maximum number of heat sources that can be rendered simultaneously
    private let maxHeatSources = 32
    
    // MARK: - Initialization
    
    override init() {
        // Get the default Metal device (GPU)
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported on this device")
        }
        self.device = device
        
        // Create command queue for submitting rendering commands
        guard let commandQueue = device.makeCommandQueue() else {
            fatalError("Failed to create Metal command queue")
        }
        self.commandQueue = commandQueue
        
        super.init()
        
        // Set up the rendering pipeline and buffers
        setupPipeline()
        setupBuffers()
    }
    
    // MARK: - Setup
    
    /// Configures the Metal rendering pipeline with vertex and fragment shaders
    private func setupPipeline() {
        // Load the default Metal library (contains our compiled shaders)
        guard let library = device.makeDefaultLibrary() else {
            print("Failed to load Metal library - ensure ThermalShader.metal is included in target")
            return
        }
        
        // Load our custom shader functions
        guard let vertexFunction = library.makeFunction(name: "thermalVertex"),
              let fragmentFunction = library.makeFunction(name: "thermalFragment") else {
            print("Failed to load shader functions")
            return
        }
        
        // Create pipeline descriptor
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        // Compile the pipeline state
        do {
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch {
            print("Failed to create pipeline state: \(error)")
        }
    }
    
    /// Creates GPU buffers for storing shader data
    private func setupBuffers() {
        // Uniform buffer: stores global shader parameters (time, resolution, etc.)
        uniformBuffer = device.makeBuffer(
            length: MemoryLayout<ThermalUniforms>.stride,
            options: .storageModeShared  // CPU/GPU shared memory
        )
        
        // Heat source buffer: stores array of heat source positions and properties
        heatSourceBuffer = device.makeBuffer(
            length: MemoryLayout<MetalHeatSource>.stride * maxHeatSources,
            options: .storageModeShared
        )
    }
    
    // MARK: - Rendering
    
    /// Main rendering function called every frame
    /// - Parameters:
    ///   - view: The MTKView to render into
    ///   - uniforms: Global shader parameters
    ///   - heatSources: Array of active heat sources
    func render(
        in view: MTKView,
        uniforms: ThermalUniforms,
        heatSources: [MetalHeatSource]
    ) {
        // Ensure we have all required resources
        guard let pipelineState = pipelineState,
              let drawable = view.currentDrawable,
              let renderPassDescriptor = view.currentRenderPassDescriptor else {
            return
        }
        
        // Update uniform buffer with current frame data
        if let uniformBuffer = uniformBuffer {
            var mutableUniforms = uniforms
            memcpy(uniformBuffer.contents(), &mutableUniforms, MemoryLayout<ThermalUniforms>.stride)
        }
        
        // Update heat source buffer with current heat sources
        if let heatSourceBuffer = heatSourceBuffer {
            var sources = heatSources
            
            // Pad array to max size with empty sources (GPU expects fixed size)
            while sources.count < maxHeatSources {
                sources.append(MetalHeatSource(
                    position: SIMD2<Float>(0, 0),
                    intensity: 0,
                    radius: 0,
                    age: 0
                ))
            }
            
            let bufferSize = MemoryLayout<MetalHeatSource>.stride * maxHeatSources
            memcpy(heatSourceBuffer.contents(), &sources, bufferSize)
        }
        
        // Create command buffer for this frame
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {
            return
        }
        
        // Set the pipeline state
        renderEncoder.setRenderPipelineState(pipelineState)
        
        // Bind buffers to fragment shader
        renderEncoder.setFragmentBuffer(uniformBuffer, offset: 0, index: 0)
        renderEncoder.setFragmentBuffer(heatSourceBuffer, offset: 0, index: 1)
        
        // Draw a full-screen quad (2 triangles = 4 vertices in triangle strip)
        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
        
        // Finish encoding
        renderEncoder.endEncoding()
        
        // Present the rendered frame
        commandBuffer.present(drawable)
        
        // Submit to GPU
        commandBuffer.commit()
    }
}

// MARK: - MTKView Delegate Coordinator

/// Coordinator that bridges MTKView's rendering lifecycle to our renderer
final class ThermalMTKViewCoordinator: NSObject, MTKViewDelegate {
    
    /// The Metal renderer instance
    private let renderer: ThermalMetalRenderer
    
    /// The heat manager containing current heat sources
    private let heatManager: ThermalHeatManager
    
    /// Timestamp of last frame (for calculating delta time)
    private var lastUpdateTime: CFTimeInterval = 0
    
    init(renderer: ThermalMetalRenderer, heatManager: ThermalHeatManager) {
        self.renderer = renderer
        self.heatManager = heatManager
        super.init()
    }
    
    /// Called when the view's drawable size changes (e.g., rotation)
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // Could update projection matrices here if needed
    }
    
    /// Called every frame to render
    @MainActor
    func draw(in view: MTKView) {
        // Calculate time since last frame
        let currentTime = CACurrentMediaTime()
        let deltaTime = lastUpdateTime == 0 ? 0 : Float(currentTime - lastUpdateTime)
        lastUpdateTime = currentTime
        
        // Update heat sources (decay intensity, remove dead sources, etc.)
        heatManager.update(deltaTime: deltaTime)
        
        // Get current view size
        let size = view.drawableSize
        
        // Prepare shader uniforms and heat sources
        let uniforms = heatManager.uniforms(for: CGSize(width: size.width, height: size.height))
        let heatSources = heatManager.metalHeatSources()
        
        // Render the frame
        renderer.render(in: view, uniforms: uniforms, heatSources: heatSources)
    }
}
