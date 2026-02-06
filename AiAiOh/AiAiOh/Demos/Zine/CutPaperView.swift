//
//  CutPaperView.swift
//  AiAiOh
//  2/6/26
//  Paper visualization showing the cutting step with animated scissors
//

import SwiftUI

// MARK: - Cut Paper View

/// Displays the paper being cut along the center crease with an animated scissors icon
struct CutPaperView: View {
    
    let size: CGSize
    let cutProgress: CGFloat
    
    var body: some View {
        ZStack {
            // Folded paper base
            FoldedPaperView(size: size, foldDirection: .horizontal, layers: 2)
            
            // Cut line animation overlay
            cutLineOverlay
        }
    }
    
    // MARK: - Cut Line Overlay
    
    private var cutLineOverlay: some View {
        GeometryReader { geometry in
            let cutLength = geometry.size.width * 0.5 * cutProgress
            let startX = geometry.size.width * 0.25
            let cutY = geometry.size.height * 0.05
            
            ZStack {
                // Cut line
                Path { path in
                    path.move(to: CGPoint(x: startX, y: cutY))
                    path.addLine(to: CGPoint(x: startX + cutLength, y: cutY))
                }
                .stroke(
                    Color.red.opacity(0.8),
                    style: StrokeStyle(lineWidth: 2, lineCap: .round)
                )
                
                // Animated scissors icon
                if cutProgress > 0 && cutProgress < 1 {
                    scissorsIcon(at: CGPoint(x: startX + cutLength, y: cutY))
                }
            }
        }
    }
    
    // MARK: - Scissors Icon
    
    private func scissorsIcon(at position: CGPoint) -> some View {
        Image(systemName: "scissors")
            .font(.system(size: 20))
            .foregroundStyle(.red.opacity(0.8))
            .position(position)
            .rotationEffect(.degrees(-45))
    }
}
