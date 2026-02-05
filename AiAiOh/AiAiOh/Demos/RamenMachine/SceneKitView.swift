//
//  SceneKitView.swift
//  AiAiOh
//  2/4/26
//  3D model viewer with gesture handling

import SwiftUI
import SceneKit

struct SceneKitView: UIViewRepresentable {
    let modelName: String
    @Binding var rotation: Float
    @Binding var shouldSpin: Bool
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.backgroundColor = .clear
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        sceneView.antialiasingMode = .multisampling4X
        
        // Create scene
        let scene = SCNScene()
        
        // Load USDZ model
        if let modelURL = Bundle.main.url(forResource: modelName, withExtension: "usdz"),
           let modelScene = try? SCNScene(url: modelURL, options: nil) {
            
            // Get the model's root node
            let modelNode = modelScene.rootNode
            
            // Scale and position the model appropriately
            let boundingBox = modelNode.boundingBox
            let size = SCNVector3(
                boundingBox.max.x - boundingBox.min.x,
                boundingBox.max.y - boundingBox.min.y,
                boundingBox.max.z - boundingBox.min.z
            )
            let maxDimension = max(size.x, max(size.y, size.z))
            let scale = 2.0 / maxDimension
            modelNode.scale = SCNVector3(scale, scale, scale)
            
            // Center the model
            let center = SCNVector3(
                (boundingBox.max.x + boundingBox.min.x) / 2,
                (boundingBox.max.y + boundingBox.min.y) / 2,
                (boundingBox.max.z + boundingBox.min.z) / 2
            )
            modelNode.position = SCNVector3(-center.x * scale, -center.y * scale, -center.z * scale)
            
            scene.rootNode.addChildNode(modelNode)
        }
        
        // Camera - positioned closer for better view
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 2.5)
        scene.rootNode.addChildNode(cameraNode)
        
        // Lighting
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.type = .directional
        lightNode.light?.intensity = 800
        lightNode.position = SCNVector3(x: 5, y: 10, z: 5)
        lightNode.look(at: SCNVector3(0, 0, 0))
        scene.rootNode.addChildNode(lightNode)
        
        // Ambient light
        let ambientNode = SCNNode()
        ambientNode.light = SCNLight()
        ambientNode.light?.type = .ambient
        ambientNode.light?.intensity = 300
        scene.rootNode.addChildNode(ambientNode)
        
        sceneView.scene = scene
        
        // Add pan gesture for rotation
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        sceneView.addGestureRecognizer(panGesture)
        
        return sceneView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {
        if shouldSpin {
            context.coordinator.performSpin(in: uiView)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(rotation: $rotation, shouldSpin: $shouldSpin)
    }
    
    class Coordinator: NSObject {
        @Binding var rotation: Float
        @Binding var shouldSpin: Bool
        
        init(rotation: Binding<Float>, shouldSpin: Binding<Bool>) {
            _rotation = rotation
            _shouldSpin = shouldSpin
        }
        
        func performSpin(in sceneView: SCNView) {
            guard let modelNode = sceneView.scene?.rootNode.childNodes.first else { return }
            
            // Create smooth 360-degree spin animation
            let spinAnimation = CABasicAnimation(keyPath: "rotation")
            spinAnimation.fromValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: modelNode.eulerAngles.y))
            spinAnimation.toValue = NSValue(scnVector4: SCNVector4(x: 0, y: 1, z: 0, w: modelNode.eulerAngles.y + Float.pi * 2))
            spinAnimation.duration = 0.8
            spinAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            
            modelNode.addAnimation(spinAnimation, forKey: "spin")
            
            // Update rotation state after animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                self.rotation = modelNode.eulerAngles.y
            }
        }
        
        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            guard let sceneView = gesture.view as? SCNView else { return }
            
            let translation = gesture.translation(in: sceneView)
            let rotationSpeed: Float = 0.01
            
            rotation += Float(translation.x) * rotationSpeed
            
            if let modelNode = sceneView.scene?.rootNode.childNodes.first {
                modelNode.eulerAngles.y = rotation
            }
            
            gesture.setTranslation(.zero, in: sceneView)
        }
    }
}
