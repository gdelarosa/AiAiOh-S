//
//  FoldedLongWaysView.swift
//  AiAiOh
//  2/6/26
//  Paper folded lengthwise showing the cut opening in the middle
//

import SwiftUI

// MARK: - Folded Long Ways View

/// Displays paper folded lengthwise with the cut opening visible as a gap in the center
struct FoldedLongWaysView: View {
    
    let size: CGSize
    
    var body: some View {
        ZStack {
            // Background paper layers
            paperLayers
            
            // Main layer with gradient
            mainLayer
            
            // Cut opening indication
            cutOpeningIndicator
            
            // Border
            borderStroke
        }
        .shadow(color: .black.opacity(0.12), radius: 6, x: 0, y: 3)
    }
    
    // MARK: - Subviews
    
    private var paperLayers: some View {
        ForEach(0..<2, id: \.self) { index in
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .offset(y: CGFloat(index) * 2)
        }
    }
    
    private var mainLayer: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(
                LinearGradient(
                    colors: [Color.white, Color(white: 0.97)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
    }
    
    private var cutOpeningIndicator: some View {
        GeometryReader { geometry in
            let centerY = geometry.size.height / 2
            let openingWidth = geometry.size.width * 0.5
            let startX = (geometry.size.width - openingWidth) / 2
            
            Path { path in
                // Top edge of opening
                path.move(to: CGPoint(x: startX, y: centerY - 3))
                path.addLine(to: CGPoint(x: startX + openingWidth, y: centerY - 3))
                
                // Bottom edge of opening
                path.move(to: CGPoint(x: startX, y: centerY + 3))
                path.addLine(to: CGPoint(x: startX + openingWidth, y: centerY + 3))
            }
            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        }
    }
    
    private var borderStroke: some View {
        RoundedRectangle(cornerRadius: 2)
            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
    }
}
