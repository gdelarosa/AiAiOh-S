//
//  CompletedZineView.swift
//  AiAiOh
//  2/6/26
//  Final completed zine visualization with celebratory glow and sparkles
//

import SwiftUI

// MARK: - Completed Zine View

/// Displays the finished 8-page zine with animated glow and sparkle decorations
struct CompletedZineView: View {
    
    let size: CGSize
    
    @State private var isGlowing: Bool = false
    
    var body: some View {
        ZStack {
            // Background glow effect
            glowEffect
            
            // Book spine shadow
            spineShaddow
            
            // Stacked pages
            pageStack
            
            // Front cover
            frontCover
            
            // Sparkle decorations
            sparkleDecorations
        }
        .shadow(color: .black.opacity(0.15), radius: 10, x: 3, y: 5)
        .onAppear {
            startGlowAnimation()
        }
    }
    
    // MARK: - Glow Effect
    
    private var glowEffect: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(Color.yellow.opacity(isGlowing ? 0.3 : 0))
            .frame(width: size.width + 20, height: size.height + 20)
            .blur(radius: 15)
    }
    
    // MARK: - Spine Shadow
    
    private var spineShaddow: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [Color.gray.opacity(0.3), Color.clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: 8, height: size.height)
            .offset(x: -size.width / 2 + 4)
    }
    
    // MARK: - Page Stack
    
    private var pageStack: some View {
        ForEach(0..<6, id: \.self) { index in
            RoundedRectangle(cornerRadius: 2)
                .fill(Color(white: 0.98))
                .frame(
                    width: size.width - CGFloat(index) * 2,
                    height: size.height
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(Color.gray.opacity(0.15), lineWidth: 0.5)
                )
                .offset(x: CGFloat(index) * 0.5)
        }
    }
    
    // MARK: - Front Cover
    
    private var frontCover: some View {
        RoundedRectangle(cornerRadius: 3)
            .fill(
                LinearGradient(
                    colors: [Color.white, Color(white: 0.95)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: size.width, height: size.height)
            .overlay(
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
            )
            .overlay(spineLineDecoration)
    }
    
    private var spineLineDecoration: some View {
        HStack {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 2)
            Spacer()
        }
        .padding(.leading, 4)
    }
    
    // MARK: - Sparkle Decorations
    
    private var sparkleDecorations: some View {
        ForEach(0..<3, id: \.self) { index in
            Image(systemName: "sparkle")
                .font(.system(size: 12))
                .foregroundStyle(.yellow.opacity(isGlowing ? 0.8 : 0.3))
                .offset(
                    x: sparkleOffset(for: index).x,
                    y: sparkleOffset(for: index).y
                )
                .offset(x: size.width / 2 + 20, y: -size.height / 2 + 20)
        }
    }
    
    private func sparkleOffset(for index: Int) -> CGPoint {
        // Deterministic offsets for consistent rendering
        let offsets: [CGPoint] = [
            CGPoint(x: -10, y: 5),
            CGPoint(x: 15, y: -15),
            CGPoint(x: -5, y: 25)
        ]
        return offsets[index % offsets.count]
    }
    
    // MARK: - Animation
    
    private func startGlowAnimation() {
        withAnimation(
            .easeInOut(duration: 1.5)
            .repeatForever(autoreverses: true)
        ) {
            isGlowing = true
        }
    }
}
