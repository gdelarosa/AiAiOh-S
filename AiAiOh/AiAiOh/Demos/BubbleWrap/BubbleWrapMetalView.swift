//
//  BubbleWrapMetalView.swift
//  AiAiOh
//  2/4/26
//  Metal view for rendering the bubble wrap
//

import SwiftUI
import MetalKit

struct BubbleWrapMetalView: UIViewRepresentable {
    var bubbleGrid: BubbleGrid
    let viewSize: CGSize
    
    func makeUIView(context: Context) -> MTKView {
        let metalView = MTKView()
        metalView.device = MTLCreateSystemDefaultDevice()
        metalView.colorPixelFormat = .bgra8Unorm
        metalView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 0)
        metalView.isOpaque = false
        metalView.backgroundColor = .clear
        metalView.delegate = context.coordinator
        metalView.preferredFramesPerSecond = 120
        metalView.enableSetNeedsDisplay = false
        metalView.isPaused = false
        context.coordinator.bubbleGrid = bubbleGrid
        context.coordinator.viewSize = viewSize
        context.coordinator.setupMetal(device: metalView.device!)
        return metalView
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
        context.coordinator.bubbleGrid = bubbleGrid
        context.coordinator.viewSize = viewSize
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    // MARK: - Coordinator
    
    class Coordinator: NSObject, MTKViewDelegate {
        var bubbleGrid: BubbleGrid!
        var viewSize: CGSize = .zero
        
        private var device: MTLDevice!
        private var commandQueue: MTLCommandQueue!
        private var pipelineState: MTLRenderPipelineState!
        private var bubbleDataBuffer: MTLBuffer?
        private var uniformBuffer: MTLBuffer?
        
        override init() {
            super.init()
        }
        
        func setupMetal(device: MTLDevice) {
            self.device = device
            self.commandQueue = device.makeCommandQueue()
            
            let library = try! device.makeLibrary(source: BubbleWrapShaders.source, options: nil)
            let vertexFunction = library.makeFunction(name: "bubbleVertex")
            let fragmentFunction = library.makeFunction(name: "bubbleFragment")
            
            let pipelineDescriptor = MTLRenderPipelineDescriptor()
            pipelineDescriptor.vertexFunction = vertexFunction
            pipelineDescriptor.fragmentFunction = fragmentFunction
            pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
            
            // Enable blending for transparency
            pipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
            pipelineDescriptor.colorAttachments[0].rgbBlendOperation = .add
            pipelineDescriptor.colorAttachments[0].alphaBlendOperation = .add
            pipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
            pipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .sourceAlpha
            pipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
            pipelineDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
            
            pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {}
        
        func draw(in view: MTKView) {
            bubbleGrid.updatePopAnimations()
            
            guard let drawable = view.currentDrawable,
                  let descriptor = view.currentRenderPassDescriptor else { return }
            
            // Update bubble data buffer
            let bubbleData = bubbleGrid.packBubbleData()
            if !bubbleData.isEmpty {
                bubbleDataBuffer = device.makeBuffer(bytes: bubbleData,
                                                      length: bubbleData.count * MemoryLayout<Float>.stride,
                                                      options: .storageModeShared)
            }
            
            // Update uniforms
            var uniforms: [Float] = [
                Float(viewSize.width),
                Float(viewSize.height),
                Float(CACurrentMediaTime()),
                Float(bubbleGrid.rows),
                Float(bubbleGrid.cols),
                bubbleGrid.bubbleRadius,
                bubbleGrid.bubbleSpacing,
                0 // padding
            ]
            uniformBuffer = device.makeBuffer(bytes: &uniforms,
                                               length: uniforms.count * MemoryLayout<Float>.stride,
                                               options: .storageModeShared)
            
            let commandBuffer = commandQueue.makeCommandBuffer()!
            let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)!
            
            encoder.setRenderPipelineState(pipelineState)
            encoder.setFragmentBuffer(uniformBuffer, offset: 0, index: 0)
            encoder.setFragmentBuffer(bubbleDataBuffer, offset: 0, index: 1)
            
            // Draw full-screen quad
            encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
            
            encoder.endEncoding()
            commandBuffer.present(drawable)
            commandBuffer.commit()
        }
    }
}
