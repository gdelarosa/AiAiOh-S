//
//  FormingPagesView.swift
//  AiAiOh
//  2/6/26
//  Animated visualization of pages forming into a booklet shape
//

import SwiftUI

// MARK: - Forming Pages View

/// Displays pages fanning out with subtle 3D rotation animation
struct FormingPagesView: View {
    
    let size: CGSize
    
    @State private var animationPhase: CGFloat = 0
    
    var body: some View {
        ZStack {
            // Multiple pages fanning out
            ForEach(0..<4, id: \.self) { index in
                pageLayer(at: index)
            }
        }
        .onAppear {
            startAnimation()
        }
    }
    
    // MARK: - Page Layer
    
    private func pageLayer(at index: Int) -> some View {
        let rotation = Double(index - 2) * 8 + sin(animationPhase) * 2
        let horizontalOffset = CGFloat(index) * 3
        
        return RoundedRectangle(cornerRadius: 2)
            .fill(Color.white)
            .frame(width: size.width * 0.8, height: size.height)
            .overlay(
                RoundedRectangle(cornerRadius: 2)
                    .stroke(Color.gray.opacity(0.25), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.05), radius: 2, x: 1, y: 1)
            .rotation3DEffect(
                .degrees(rotation),
                axis: (x: 0, y: 1, z: 0),
                anchor: .leading,
                perspective: 0.5
            )
            .offset(x: horizontalOffset)
    }
    
    // MARK: - Animation
    
    private func startAnimation() {
        withAnimation(
            .easeInOut(duration: 2)
            .repeatForever(autoreverses: true)
        ) {
            animationPhase = .pi * 2
        }
    }
}
