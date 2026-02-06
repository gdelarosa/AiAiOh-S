//
//  FoldedPaperView.swift
//  AiAiOh
//  2/6/26
//  Folded paper visualization showing layered thickness and fold edges
//

import SwiftUI

// MARK: - Fold Direction

/// Direction of the paper fold
enum FoldDirection {
    case vertical
    case horizontal
    case both
}

// MARK: - Folded Paper View

/// Displays paper in a folded state with visible layer thickness
struct FoldedPaperView: View {
    
    let size: CGSize
    let foldDirection: FoldDirection
    let layers: Int
    
    var body: some View {
        ZStack {
            // Stacked layers to show thickness
            layerStack
            
            // Top layer with gradient
            topLayer
            
            // Fold edge indicator
            foldEdgeIndicator
            
            // Border
            borderStroke
        }
        .shadow(color: .black.opacity(0.12), radius: 6, x: 2, y: 3)
    }
    
    // MARK: - Subviews
    
    private var layerStack: some View {
        ForEach(0..<min(layers, 4), id: \.self) { index in
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .offset(x: CGFloat(index) * 1.5, y: CGFloat(index) * 1.5)
        }
    }
    
    private var topLayer: some View {
        RoundedRectangle(cornerRadius: 2)
            .fill(
                LinearGradient(
                    colors: [Color.white, Color(white: 0.96)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
    }
    
    private var borderStroke: some View {
        RoundedRectangle(cornerRadius: 2)
            .stroke(Color.gray.opacity(0.4), lineWidth: 1)
    }
    
    // MARK: - Fold Edge Indicator
    
    @ViewBuilder
    private var foldEdgeIndicator: some View {
        switch foldDirection {
        case .vertical:
            verticalFoldEdge
        case .horizontal:
            horizontalFoldEdge
        case .both:
            bothFoldEdges
        }
    }
    
    private var verticalFoldEdge: some View {
        HStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.gray.opacity(0.15), Color.clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(width: 8)
            Spacer()
        }
    }
    
    private var horizontalFoldEdge: some View {
        VStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [Color.gray.opacity(0.15), Color.clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 8)
            Spacer()
        }
    }
    
    private var bothFoldEdges: some View {
        ZStack {
            HStack {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color.gray.opacity(0.15), Color.clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 6)
                Spacer()
            }
            VStack {
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [Color.gray.opacity(0.15), Color.clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 6)
                Spacer()
            }
        }
    }
}
