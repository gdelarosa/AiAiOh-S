//
//  FlatPaperView.swift
//  AiAiOh
//  2/6/26
//  Flat paper visualization for the initial state of the zine tutorial
//

import SwiftUI

// MARK: - Flat Paper View

/// Displays a flat, unfolded sheet of paper with subtle depth and shadow
struct FlatPaperView: View {
    
    let size: CGSize
    
    var body: some View {
        ZStack {
            // Paper base with gradient
            paperBase
            
            // Subtle texture overlay
            textureOverlay
            
            // Border stroke
            borderStroke
            
            // Shadow hint for depth
            shadowHint
        }
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
    
    // MARK: - Subviews
    
    private var paperBase: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(
                LinearGradient(
                    colors: [Color.white, Color(white: 0.98)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
    
    private var textureOverlay: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(Color.gray.opacity(0.03))
    }
    
    private var borderStroke: some View {
        RoundedRectangle(cornerRadius: 2)
            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
    }
    
    private var shadowHint: some View {
        RoundedRectangle(cornerRadius: 2)
            .stroke(Color.black.opacity(0.1), lineWidth: 0.5)
            .offset(x: 1, y: 1)
    }
}
