//
//  RoboticDemoView.swift
//  AiAiOh
//  2/10/26
//  RealityKit showcase displaying an animated robot hand
//

import SwiftUI
import RealityKit
import ARKit

// MARK: - Premium Robotic Demo View

struct RoboticDemoView: View {
    @State private var hasAppeared = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color(.systemBackground).opacity(0.94)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            PremiumRobotARView()
                .opacity(hasAppeared ? 1 : 0)
                .scaleEffect(hasAppeared ? 1 : 0.92)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Old Mac's Hand")
                    .font(.system(size: 17, weight: .medium, design: .monospaced))
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.75)) {
                hasAppeared = true
            }
        }
    }
}

// MARK: - RealityKit View

struct PremiumRobotARView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.environment.background = .color(.clear)
        arView.automaticallyConfigureSession = false
        
        // Non-AR camera mode (clean demo mode)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = []
        arView.session.run(config)
        
        // Root anchor
        let rootAnchor = AnchorEntity(world: .zero)
        arView.scene.addAnchor(rootAnchor)
        
        // Add camera
        let camera = PerspectiveCamera()
        let cameraAnchor = AnchorEntity(world: [0, 0, 0])
        camera.position = [0, 0, 800]
        cameraAnchor.addChild(camera)
        arView.scene.addAnchor(cameraAnchor)
        
        // Studio lighting
        addStudioLighting(to: rootAnchor)
        
        // Load model
        loadRobot(into: rootAnchor)
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    // MARK: - Model Loading
    
    private func loadRobot(into anchor: AnchorEntity) {
        do {
            let robot = try ModelEntity.loadModel(named: "Robot_Hand_Dying")
            
            // Center model using bounds
            let bounds = robot.visualBounds(relativeTo: nil)
            let center = bounds.center
            let extents = bounds.extents
            robot.position = -center
            
            // Normalize scale
            let maxDimension = max(extents.x, extents.y, extents.z)
            let desiredSize: Float = 0.35
            let scaleFactor = desiredSize / maxDimension
            robot.scale = [scaleFactor, scaleFactor, scaleFactor]
            
            // Move slightly forward
            robot.position.z -= 3.5
            
            // Rotation
            robot.transform.rotation = simd_quatf(angle: .pi/2, axis: [0,1,0])
            
            anchor.addChild(robot)
            
            // Add floating shadow plane
            addShadowPlane(below: robot, anchor: anchor)
            
            // Start animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                animateRobot(robot)
            }
            
        } catch {
            print("Failed to load robot: \(error)")
        }
    }
    
    // MARK: - Studio Lighting
    
    private func addStudioLighting(to anchor: AnchorEntity) {
        // Key light
        let keyLight = DirectionalLight()
        keyLight.light.intensity = 1800
        keyLight.light.color = .white
        keyLight.position = [2, 3, 3]
        keyLight.look(at: .zero, from: keyLight.position, relativeTo: nil)
        anchor.addChild(keyLight)
        
        // Fill light
        let fillLight = DirectionalLight()
        fillLight.light.intensity = 600
        fillLight.light.color = .white
        fillLight.position = [-3, 2, 2]
        fillLight.look(at: .zero, from: fillLight.position, relativeTo: nil)
        anchor.addChild(fillLight)
        
        // Rim light
        let rimLight = DirectionalLight()
        rimLight.light.intensity = 900
        rimLight.light.color = .white
        rimLight.position = [0, 3, -3]
        rimLight.look(at: .zero, from: rimLight.position, relativeTo: nil)
        anchor.addChild(rimLight)
    }
    
    // MARK: - Shadow Plane
    
    private func addShadowPlane(below model: ModelEntity, anchor: AnchorEntity) {
        let planeMesh = MeshResource.generatePlane(width: 2, depth: 2)
        var material = SimpleMaterial()
        material.color = .init(tint: .black.withAlphaComponent(0.15))
        material.roughness = 1.0
        
        let plane = ModelEntity(mesh: planeMesh, materials: [material])
        plane.position = [0, -0.35, -1.2]
        anchor.addChild(plane)
    }
    
    // MARK: - Animation
    
    private func animateRobot(_ entity: ModelEntity) {
        let rotation = Transform(
            pitch: 0,
            yaw: .pi * 2,
            roll: 0
        )
        
        entity.move(
            to: rotation,
            relativeTo: entity.parent,
            duration: 8.0,
            timingFunction: .linear
        )
        
        if let first = entity.availableAnimations.first {
            entity.playAnimation(first.repeat())
        }
    }
}
