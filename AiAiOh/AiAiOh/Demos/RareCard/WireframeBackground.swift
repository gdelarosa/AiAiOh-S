//
//  WireframeBackground.swift
//  AiAiOh
//
//  Created by Gina on 2/6/26.
//

import SwiftUI

// MARK: - Wireframe Background

struct WireframeBackground: View {
    var body: some View {
        Canvas { context, size in
            let lineSpacing: CGFloat = 8
            
            // Horizontal lines - ground plane
            for i in 0..<Int(size.height / lineSpacing) {
                let y = CGFloat(i) * lineSpacing
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(
                    path,
                    with: .color(.green.opacity(0.5)),
                    lineWidth: 0.5
                )
            }
            
            // Background elements
            drawCrystalMountains(context: context, size: size)
            drawFloatingIslands(context: context, size: size)
            drawGeometricClouds(context: context, size: size)
            
            // Main character - "Lumpo" the blob knight
            drawLumpo(context: context, centerX: size.width * 0.5, centerY: size.height * 0.55, scale: 1.0)
            
            // Foreground elements
            drawMushrooms(context: context, size: size)
            drawGeometricGrass(context: context, size: size)
            drawTinyCreatures(context: context, size: size)
        }
    }
}

// MARK: - Background Elements

private func drawCrystalMountains(context: GraphicsContext, size: CGSize) {
    var path = Path()
    
    // Jagged crystal peaks in background
    let peaks: [(x: CGFloat, height: CGFloat, width: CGFloat)] = [
        (size.width * 0.2, 45, 30),
        (size.width * 0.4, 55, 35),
        (size.width * 0.6, 50, 32),
        (size.width * 0.8, 40, 28)
    ]
    
    for peak in peaks {
        let baseY = size.height * 0.75
        
        // Main peak - angular crystal
        path.move(to: CGPoint(x: peak.x - peak.width/2, y: baseY))
        path.addLine(to: CGPoint(x: peak.x - peak.width/4, y: baseY - peak.height * 0.6))
        path.addLine(to: CGPoint(x: peak.x, y: baseY - peak.height))
        path.addLine(to: CGPoint(x: peak.x + peak.width/4, y: baseY - peak.height * 0.6))
        path.addLine(to: CGPoint(x: peak.x + peak.width/2, y: baseY))
        
        // Internal facets
        path.move(to: CGPoint(x: peak.x, y: baseY - peak.height))
        path.addLine(to: CGPoint(x: peak.x, y: baseY))
        
        path.move(to: CGPoint(x: peak.x - peak.width/4, y: baseY - peak.height * 0.6))
        path.addLine(to: CGPoint(x: peak.x + peak.width/4, y: baseY - peak.height * 0.6))
    }
    
    context.stroke(path, with: .color(.green.opacity(0.6)), lineWidth: 1)
}

private func drawFloatingIslands(context: GraphicsContext, size: CGSize) {
    var path = Path()
    
    // Small floating islands
    let islands: [(x: CGFloat, y: CGFloat, width: CGFloat)] = [
        (size.width * 0.15, size.height * 0.25, 20),
        (size.width * 0.85, size.height * 0.3, 15)
    ]
    
    for island in islands {
        // Island base - rounded bottom
        path.move(to: CGPoint(x: island.x - island.width/2, y: island.y))
        path.addQuadCurve(
            to: CGPoint(x: island.x + island.width/2, y: island.y),
            control: CGPoint(x: island.x, y: island.y + 8)
        )
        
        // Top surface
        path.move(to: CGPoint(x: island.x - island.width/2, y: island.y))
        path.addLine(to: CGPoint(x: island.x - island.width/3, y: island.y - 5))
        path.addLine(to: CGPoint(x: island.x + island.width/3, y: island.y - 5))
        path.addLine(to: CGPoint(x: island.x + island.width/2, y: island.y))
        
        // Grass tufts
        for i in 0..<3 {
            let xOff = island.x - island.width/4 + CGFloat(i) * island.width/4
            path.move(to: CGPoint(x: xOff, y: island.y - 5))
            path.addLine(to: CGPoint(x: xOff - 2, y: island.y - 10))
            path.move(to: CGPoint(x: xOff, y: island.y - 5))
            path.addLine(to: CGPoint(x: xOff + 2, y: island.y - 10))
        }
    }
    
    context.stroke(path, with: .color(.green.opacity(0.5)), lineWidth: 1)
}

private func drawGeometricClouds(context: GraphicsContext, size: CGSize) {
    var path = Path()
    
    // Geometric puffy clouds
    let clouds: [(x: CGFloat, y: CGFloat)] = [
        (size.width * 0.3, size.height * 0.15),
        (size.width * 0.7, size.height * 0.2)
    ]
    
    for cloud in clouds {
        // Three overlapping circles making a cloud
        for i in 0..<3 {
            let xOffset = CGFloat(i - 1) * 8
            path.addEllipse(in: CGRect(x: cloud.x + xOffset - 6, y: cloud.y - 6, width: 12, height: 12))
        }
    }
    
    context.stroke(path, with: .color(.green.opacity(0.4)), lineWidth: 0.8)
}

// MARK: - Character: Lumpo the Blob Knight

private func drawLumpo(context: GraphicsContext, centerX: CGFloat, centerY: CGFloat, scale: CGFloat) {
    var path = Path()
    let s = scale
    
    // Main blob body - rounded organic shape
    path.move(to: CGPoint(x: centerX - 25*s, y: centerY + 15*s))
    path.addQuadCurve(
        to: CGPoint(x: centerX - 20*s, y: centerY - 15*s),
        control: CGPoint(x: centerX - 30*s, y: centerY)
    )
    path.addQuadCurve(
        to: CGPoint(x: centerX + 20*s, y: centerY - 15*s),
        control: CGPoint(x: centerX, y: centerY - 25*s)
    )
    path.addQuadCurve(
        to: CGPoint(x: centerX + 25*s, y: centerY + 15*s),
        control: CGPoint(x: centerX + 30*s, y: centerY)
    )
    path.addQuadCurve(
        to: CGPoint(x: centerX - 25*s, y: centerY + 15*s),
        control: CGPoint(x: centerX, y: centerY + 25*s)
    )
    
    // Knight helmet - geometric crown shape
    path.move(to: CGPoint(x: centerX - 15*s, y: centerY - 15*s))
    path.addLine(to: CGPoint(x: centerX - 15*s, y: centerY - 30*s))
    path.addLine(to: CGPoint(x: centerX - 8*s, y: centerY - 35*s))
    path.addLine(to: CGPoint(x: centerX, y: centerY - 32*s))
    path.addLine(to: CGPoint(x: centerX + 8*s, y: centerY - 35*s))
    path.addLine(to: CGPoint(x: centerX + 15*s, y: centerY - 30*s))
    path.addLine(to: CGPoint(x: centerX + 15*s, y: centerY - 15*s))
    
    // Visor slit
    path.move(to: CGPoint(x: centerX - 12*s, y: centerY - 20*s))
    path.addLine(to: CGPoint(x: centerX + 12*s, y: centerY - 20*s))
    
    // Happy eyes - big circles
    let leftEyeX = centerX - 8*s
    let rightEyeX = centerX + 8*s
    let eyeY = centerY - 5*s
    
    path.addEllipse(in: CGRect(x: leftEyeX - 4*s, y: eyeY - 4*s, width: 8*s, height: 8*s))
    path.addEllipse(in: CGRect(x: rightEyeX - 4*s, y: eyeY - 4*s, width: 8*s, height: 8*s))
    
    // Big goofy smile - curved
    path.move(to: CGPoint(x: centerX - 10*s, y: centerY + 5*s))
    path.addQuadCurve(
        to: CGPoint(x: centerX + 10*s, y: centerY + 5*s),
        control: CGPoint(x: centerX, y: centerY + 12*s)
    )
    
    // Stubby arms
    // Left arm
    path.move(to: CGPoint(x: centerX - 25*s, y: centerY + 5*s))
    path.addLine(to: CGPoint(x: centerX - 38*s, y: centerY + 8*s))
    path.addLine(to: CGPoint(x: centerX - 40*s, y: centerY + 15*s))
    path.addLine(to: CGPoint(x: centerX - 35*s, y: centerY + 18*s))
    
    // Right arm holding sword
    path.move(to: CGPoint(x: centerX + 25*s, y: centerY + 5*s))
    path.addLine(to: CGPoint(x: centerX + 35*s, y: centerY))
    
    // Magical sword - geometric blade
    path.move(to: CGPoint(x: centerX + 35*s, y: centerY))
    path.addLine(to: CGPoint(x: centerX + 45*s, y: centerY - 25*s))
    path.addLine(to: CGPoint(x: centerX + 48*s, y: centerY - 25*s))
    path.addLine(to: CGPoint(x: centerX + 38*s, y: centerY))
    path.addLine(to: CGPoint(x: centerX + 35*s, y: centerY))
    
    // Sword guard
    path.move(to: CGPoint(x: centerX + 30*s, y: centerY))
    path.addLine(to: CGPoint(x: centerX + 42*s, y: centerY))
    
    // Sparkles around sword
    drawSparkle(path: &path, x: centerX + 48*s, y: centerY - 30*s, size: 3*s)
    drawSparkle(path: &path, x: centerX + 50*s, y: centerY - 20*s, size: 2*s)
    
    // Belly pattern - horizontal stripes
    for i in 0..<3 {
        let y = centerY + CGFloat(i) * 5*s
        path.move(to: CGPoint(x: centerX - 15*s, y: y))
        path.addLine(to: CGPoint(x: centerX + 15*s, y: y))
    }
    
    context.stroke(path, with: .color(.green), lineWidth: 1.5)
    
    // Fill eyes
    var eyeFill = Path()
    eyeFill.addEllipse(in: CGRect(x: leftEyeX - 3*s, y: eyeY - 3*s, width: 6*s, height: 6*s))
    eyeFill.addEllipse(in: CGRect(x: rightEyeX - 3*s, y: eyeY - 3*s, width: 6*s, height: 6*s))
    context.fill(eyeFill, with: .color(.green))
}



// MARK: - Foreground Elements

private func drawMushrooms(context: GraphicsContext, size: CGSize) {
    var path = Path()
    
    let mushrooms: [(x: CGFloat, y: CGFloat, capWidth: CGFloat)] = [
        (size.width * 0.12, size.height * 0.85, 18),
        (size.width * 0.88, size.height * 0.83, 15)
    ]
    
    for mush in mushrooms {
        // Stem
        path.move(to: CGPoint(x: mush.x - 3, y: mush.y))
        path.addLine(to: CGPoint(x: mush.x - 3, y: mush.y - 12))
        path.addLine(to: CGPoint(x: mush.x + 3, y: mush.y - 12))
        path.addLine(to: CGPoint(x: mush.x + 3, y: mush.y))
        
        // Cap - dome shape with spots
        path.move(to: CGPoint(x: mush.x - mush.capWidth/2, y: mush.y - 12))
        path.addQuadCurve(
            to: CGPoint(x: mush.x + mush.capWidth/2, y: mush.y - 12),
            control: CGPoint(x: mush.x, y: mush.y - 25)
        )
        path.addLine(to: CGPoint(x: mush.x - mush.capWidth/2, y: mush.y - 12))
        
        // Spots
        for i in 0..<3 {
            let spotX = mush.x - mush.capWidth/3 + CGFloat(i) * mush.capWidth/3
            path.addEllipse(in: CGRect(x: spotX - 2, y: mush.y - 20, width: 4, height: 4))
        }
    }
    
    context.stroke(path, with: .color(.green), lineWidth: 1.2)
}

private func drawGeometricGrass(context: GraphicsContext, size: CGSize) {
    var path = Path()
    
    // Scattered geometric grass blades
    for i in 0..<15 {
        let x = size.width * 0.1 + CGFloat(i) * (size.width * 0.8 / 15)
        let baseY = size.height * 0.92
        let height = CGFloat.random(in: 8...15)
        
        // Zigzag blade
        path.move(to: CGPoint(x: x, y: baseY))
        path.addLine(to: CGPoint(x: x - 2, y: baseY - height/2))
        path.addLine(to: CGPoint(x: x + 1, y: baseY - height))
    }
    
    context.stroke(path, with: .color(.green.opacity(0.6)), lineWidth: 0.8)
}

private func drawTinyCreatures(context: GraphicsContext, size: CGSize) {
    var path = Path()
    
    // Little companion blob friends
    let critters: [(x: CGFloat, y: CGFloat)] = [
        (size.width * 0.25, size.height * 0.88),
        (size.width * 0.75, size.height * 0.87)
    ]
    
    for critter in critters {
        // Body - small blob
        path.addEllipse(in: CGRect(x: critter.x - 5, y: critter.y - 8, width: 10, height: 10))
        
        // Eyes - two dots
        path.move(to: CGPoint(x: critter.x - 2, y: critter.y - 5))
        path.addLine(to: CGPoint(x: critter.x - 2, y: critter.y - 4))
        path.move(to: CGPoint(x: critter.x + 2, y: critter.y - 5))
        path.addLine(to: CGPoint(x: critter.x + 2, y: critter.y - 4))
        
        // Antenna
        path.move(to: CGPoint(x: critter.x, y: critter.y - 8))
        path.addLine(to: CGPoint(x: critter.x, y: critter.y - 13))
        path.addEllipse(in: CGRect(x: critter.x - 2, y: critter.y - 15, width: 4, height: 4))
    }
    
    context.stroke(path, with: .color(.green), lineWidth: 1)
}

// MARK: - Helper Functions

private func drawSparkle(path: inout Path, x: CGFloat, y: CGFloat, size: CGFloat) {
    // Four-pointed star sparkle
    path.move(to: CGPoint(x: x, y: y - size))
    path.addLine(to: CGPoint(x: x, y: y + size))
    path.move(to: CGPoint(x: x - size, y: y))
    path.addLine(to: CGPoint(x: x + size, y: y))
}

private func drawTree(context: GraphicsContext, x: CGFloat, y: CGFloat) {
    var path = Path()
    // Trunk
    path.move(to: CGPoint(x: x, y: y))
    path.addLine(to: CGPoint(x: x, y: y - 20))
    
    // Triangular foliage
    for i in 0..<3 {
        let yOffset = CGFloat(i) * 8
        let width = CGFloat(20 - i * 4)
        path.move(to: CGPoint(x: x - width/2, y: y - 20 - yOffset))
        path.addLine(to: CGPoint(x: x, y: y - 28 - yOffset))
        path.addLine(to: CGPoint(x: x + width/2, y: y - 20 - yOffset))
    }
    
    context.stroke(path, with: .color(.green), lineWidth: 1)
}

private func drawFish(context: GraphicsContext, centerX: CGFloat, centerY: CGFloat, scale: CGFloat) {
    var path = Path()
    
    // Scale all dimensions
    let s = scale
    
    // Body - rounded geometric shape
    // Top curve of body
    path.move(to: CGPoint(x: centerX - 30*s, y: centerY))
    path.addQuadCurve(
        to: CGPoint(x: centerX + 25*s, y: centerY - 15*s),
        control: CGPoint(x: centerX, y: centerY - 25*s)
    )
    
    // Bottom curve of body
    path.move(to: CGPoint(x: centerX - 30*s, y: centerY))
    path.addQuadCurve(
        to: CGPoint(x: centerX + 25*s, y: centerY + 15*s),
        control: CGPoint(x: centerX, y: centerY + 25*s)
    )
    
    // Connect tail end
    path.move(to: CGPoint(x: centerX + 25*s, y: centerY - 15*s))
    path.addLine(to: CGPoint(x: centerX + 25*s, y: centerY + 15*s))
    
    // Tail fin - angular triangular shape
    path.move(to: CGPoint(x: centerX + 25*s, y: centerY - 15*s))
    path.addLine(to: CGPoint(x: centerX + 45*s, y: centerY - 25*s))
    path.addLine(to: CGPoint(x: centerX + 40*s, y: centerY))
    
    path.move(to: CGPoint(x: centerX + 25*s, y: centerY + 15*s))
    path.addLine(to: CGPoint(x: centerX + 45*s, y: centerY + 25*s))
    path.addLine(to: CGPoint(x: centerX + 40*s, y: centerY))
    
    // Middle tail spine
    path.move(to: CGPoint(x: centerX + 25*s, y: centerY))
    path.addLine(to: CGPoint(x: centerX + 40*s, y: centerY))
    
    // Top fin - dorsal
    path.move(to: CGPoint(x: centerX - 5*s, y: centerY - 25*s))
    path.addLine(to: CGPoint(x: centerX, y: centerY - 35*s))
    path.addLine(to: CGPoint(x: centerX + 10*s, y: centerY - 30*s))
    path.addLine(to: CGPoint(x: centerX + 15*s, y: centerY - 15*s))
    
    // Bottom fin - pectoral
    path.move(to: CGPoint(x: centerX - 10*s, y: centerY + 10*s))
    path.addLine(to: CGPoint(x: centerX - 15*s, y: centerY + 25*s))
    path.addLine(to: CGPoint(x: centerX - 5*s, y: centerY + 22*s))
    
    // Eye - simple circle
    let eyeCenter = CGPoint(x: centerX - 15*s, y: centerY - 5*s)
    path.addEllipse(in: CGRect(
        x: eyeCenter.x - 4*s,
        y: eyeCenter.y - 4*s,
        width: 8*s,
        height: 8*s
    ))
    
    // Gill lines - three curved lines
    for i in 0..<3 {
        let xOffset = CGFloat(i) * 5*s
        path.move(to: CGPoint(x: centerX - 20*s + xOffset, y: centerY + 5*s))
        path.addQuadCurve(
            to: CGPoint(x: centerX - 15*s + xOffset, y: centerY + 15*s),
            control: CGPoint(x: centerX - 18*s + xOffset, y: centerY + 8*s)
        )
    }
    
    // Body facets/panels - geometric divisions
    path.move(to: CGPoint(x: centerX - 10*s, y: centerY - 20*s))
    path.addLine(to: CGPoint(x: centerX - 10*s, y: centerY + 20*s))
    
    path.move(to: CGPoint(x: centerX + 5*s, y: centerY - 18*s))
    path.addLine(to: CGPoint(x: centerX + 5*s, y: centerY + 18*s))
    
    // Stroke everything with thicker line for visibility
    context.stroke(path, with: .color(.green), lineWidth: 1.5)
    
    // Fill the eye
    var eyePath = Path()
    eyePath.addEllipse(in: CGRect(
        x: eyeCenter.x - 3*s,
        y: eyeCenter.y - 3*s,
        width: 6*s,
        height: 6*s
    ))
    context.fill(eyePath, with: .color(.green))
}

// MARK: - Scanline Overlay

struct ScanlineOverlay: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ForEach(0..<Int(geometry.size.height / 2), id: \.self) { _ in
                    Rectangle()
                        .fill(.green)
                        .frame(height: 1)
                    
                    Rectangle()
                        .fill(.clear)
                        .frame(height: 1)
                }
            }
        }
    }
}

// MARK: - Animated Gradient View

struct AnimatedGradientView: View {
    let colors: [Color]
    let phase: Double
    
    var body: some View {
        LinearGradient(
            colors: colors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .hueRotation(.degrees(phase * 360))
    }
}

// MARK: - Hexagon Shape

struct HexagonShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let center = CGPoint(x: width / 2, y: height / 2)
        
        // Hexagon has 6 points
        let radius = min(width, height) / 2
        
        for i in 0..<6 {
            let angle = CGFloat(i) * .pi / 3 - .pi / 2
            let x = center.x + radius * cos(angle)
            let y = center.y + radius * sin(angle)
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        path.closeSubpath()
        return path
    }
}

