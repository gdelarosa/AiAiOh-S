//
//  CreasedPaperView.swift
//  AiAiOh
//  2/6/26
//  Unfolded paper visualization with visible crease lines rendered via Canvas
//

import SwiftUI

// MARK: - Creased Paper View

/// Displays unfolded paper with visible crease lines dividing it into 8 sections
/// Optionally shows a cut line through the center
struct CreasedPaperView: View {
    
    let size: CGSize
    let showCut: Bool
    
    var body: some View {
        Canvas { context, canvasSize in
            let rect = CGRect(origin: .zero, size: canvasSize)
            
            // Draw paper background
            drawPaperBackground(context: context, rect: rect)
            
            // Draw vertical crease lines (3 lines dividing into 4 columns)
            drawVerticalCreases(context: context, size: canvasSize)
            
            // Draw horizontal crease line (1 line in middle)
            drawHorizontalCrease(context: context, size: canvasSize)
            
            // Draw cut line if showing
            if showCut {
                drawCutLine(context: context, size: canvasSize)
            }
            
            // Draw border
            drawBorder(context: context, rect: rect)
        }
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Drawing Methods
    
    private func drawPaperBackground(context: GraphicsContext, rect: CGRect) {
        context.fill(
            Path(roundedRect: rect, cornerRadius: 2),
            with: .color(.white)
        )
    }
    
    private func drawVerticalCreases(context: GraphicsContext, size: CGSize) {
        let creaseColor = Color.gray.opacity(0.25)
        
        for i in 1...3 {
            let x = size.width * CGFloat(i) / 4
            var path = Path()
            path.move(to: CGPoint(x: x, y: 0))
            path.addLine(to: CGPoint(x: x, y: size.height))
            
            context.stroke(
                path,
                with: .color(creaseColor),
                style: StrokeStyle(lineWidth: 1, dash: [4, 2])
            )
        }
    }
    
    private func drawHorizontalCrease(context: GraphicsContext, size: CGSize) {
        let creaseColor = Color.gray.opacity(0.25)
        
        var path = Path()
        path.move(to: CGPoint(x: 0, y: size.height / 2))
        path.addLine(to: CGPoint(x: size.width, y: size.height / 2))
        
        context.stroke(
            path,
            with: .color(creaseColor),
            style: StrokeStyle(lineWidth: 1, dash: [4, 2])
        )
    }
    
    private func drawCutLine(context: GraphicsContext, size: CGSize) {
        let cutStartX = size.width / 4
        let cutEndX = size.width * 3 / 4
        let cutY = size.height / 2
        
        // Main cut line
        var cutPath = Path()
        cutPath.move(to: CGPoint(x: cutStartX, y: cutY))
        cutPath.addLine(to: CGPoint(x: cutEndX, y: cutY))
        
        context.stroke(
            cutPath,
            with: .color(Color.red.opacity(0.6)),
            style: StrokeStyle(lineWidth: 2)
        )
        
        // Left triangle indicator
        let triangleSize: CGFloat = 6
        var leftTriangle = Path()
        leftTriangle.move(to: CGPoint(x: cutStartX, y: cutY - triangleSize))
        leftTriangle.addLine(to: CGPoint(x: cutStartX + triangleSize, y: cutY))
        leftTriangle.addLine(to: CGPoint(x: cutStartX, y: cutY + triangleSize))
        leftTriangle.closeSubpath()
        
        context.fill(leftTriangle, with: .color(Color.red.opacity(0.4)))
        
        // Right triangle indicator
        var rightTriangle = Path()
        rightTriangle.move(to: CGPoint(x: cutEndX, y: cutY - triangleSize))
        rightTriangle.addLine(to: CGPoint(x: cutEndX - triangleSize, y: cutY))
        rightTriangle.addLine(to: CGPoint(x: cutEndX, y: cutY + triangleSize))
        rightTriangle.closeSubpath()
        
        context.fill(rightTriangle, with: .color(Color.red.opacity(0.4)))
    }
    
    private func drawBorder(context: GraphicsContext, rect: CGRect) {
        context.stroke(
            Path(roundedRect: rect, cornerRadius: 2),
            with: .color(Color.gray.opacity(0.3)),
            lineWidth: 1
        )
    }
}
