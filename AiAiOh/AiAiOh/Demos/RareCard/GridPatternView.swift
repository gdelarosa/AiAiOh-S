//
//  GridPatternView.swift
//  AiAiOh
//  2/6/26
//  Grid layer for card

import SwiftUI

// MARK: - Grid Pattern

struct GridPattern: View {
    var body: some View {
        Canvas { context, size in
            let spacing: CGFloat = 40
            
            // Vertical lines
            for i in 0..<Int(size.width / spacing) {
                let x = CGFloat(i) * spacing
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(path, with: .color(.green.opacity(0.3)), lineWidth: 0.5)
            }
            
            // Horizontal lines
            for i in 0..<Int(size.height / spacing) {
                let y = CGFloat(i) * spacing
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path, with: .color(.green.opacity(0.3)), lineWidth: 0.5)
            }
        }
    }
}
