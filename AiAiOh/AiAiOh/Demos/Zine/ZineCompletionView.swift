//
//  ZineCompletionView.swift
//  AiAiOh
//  2/6/26
//  Celebration view displayed when user completes the zine tutorial
//

import SwiftUI

// MARK: - Zine Completion View

/// Celebration sheet shown upon completing the zine folding tutorial
struct ZineCompletionView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var showConfetti: Bool = false
    @State private var zineScale: CGFloat = 0.5
    @State private var zineRotation: Double = -10
    
    var body: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color.yellow.opacity(0.05),
                    Color(.systemBackground)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // Confetti particles
            if showConfetti {
                ConfettiView()
            }
            
            VStack(spacing: 32) {
                Spacer()
                
                // Success icon with zine
                ZStack {
                    // Glow
                    Circle()
                        .fill(Color.yellow.opacity(0.2))
                        .frame(width: 160, height: 160)
                        .blur(radius: 30)
                    
                    // Mini zine illustration
                    MiniZineIllustration()
                        .frame(width: 80, height: 100)
                        .scaleEffect(zineScale)
                        .rotationEffect(.degrees(zineRotation))
                }
                
                // Title
                VStack(spacing: 12) {
                    Text("You Did It!")
                        .font(.system(size: 32, weight: .light, design: .serif))
                        .foregroundStyle(.primary)
                    
                    Text("Your 8-page zine is ready")
                        .font(.system(size: 16, weight: .regular, design: .default))
                        .foregroundStyle(.secondary)
                }
                
                // Tips section
                VStack(alignment: .leading, spacing: 16) {
                    Text("NEXT STEPS")
                        .font(.system(size: 11, weight: .semibold, design: .monospaced))
                        .tracking(2)
                        .foregroundStyle(.secondary)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        TipRow(icon: "pencil.and.outline", text: "Draw your cover design")
                        TipRow(icon: "text.alignleft", text: "Add stories or poems")
                        TipRow(icon: "camera", text: "Paste in photos or collage")
                        TipRow(icon: "gift", text: "Share with friends")
                    }
                }
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.secondarySystemBackground))
                )
                .padding(.horizontal, 32)
                
                Spacer()
                
                // Dismiss button
                Button(action: { dismiss() }) {
                    Text("Make Another")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.primary)
                        )
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.2)) {
                zineScale = 1.0
                zineRotation = 5
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showConfetti = true
            }
        }
    }
}

// MARK: - Tip Row

struct TipRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(.secondary)
                .frame(width: 24)
            
            Text(text)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.primary)
        }
    }
}

// MARK: - Mini Zine Illustration

struct MiniZineIllustration: View {
    var body: some View {
        ZStack {
            // Pages
            ForEach(0..<4, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(white: 0.98))
                    .overlay(
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                    )
                    .offset(x: CGFloat(index) * 1)
            }
            
            // Cover
            RoundedRectangle(cornerRadius: 3)
                .fill(
                    LinearGradient(
                        colors: [Color.white, Color(white: 0.95)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                )
                .overlay(
                    VStack {
                        // Simple cover decoration
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.gray.opacity(0.1))
                            .frame(width: 40, height: 6)
                        
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.gray.opacity(0.08))
                            .frame(width: 30, height: 4)
                    }
                    .padding(.top, 20)
                )
        }
        .shadow(color: .black.opacity(0.15), radius: 8, x: 2, y: 4)
    }
}

// MARK: - Confetti View

struct ConfettiView: View {
    
    @State private var particles: [ConfettiParticle] = []
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    ConfettiPiece(particle: particle)
                }
            }
            .onAppear {
                createParticles(in: geometry.size)
            }
        }
    }
    
    private func createParticles(in size: CGSize) {
        particles = (0..<50).map { _ in
            ConfettiParticle(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: -100...0),
                color: [Color.yellow, Color.orange, Color.pink, Color.purple, Color.blue, Color.green].randomElement()!,
                size: CGFloat.random(in: 6...12),
                rotation: Double.random(in: 0...360),
                delay: Double.random(in: 0...0.5)
            )
        }
    }
}

struct ConfettiParticle: Identifiable {
    let id = UUID()
    let x: CGFloat
    let y: CGFloat
    let color: Color
    let size: CGFloat
    let rotation: Double
    let delay: Double
}

struct ConfettiPiece: View {
    let particle: ConfettiParticle
    
    @State private var offsetY: CGFloat = 0
    @State private var opacity: Double = 1
    @State private var currentRotation: Double = 0
    
    var body: some View {
        Rectangle()
            .fill(particle.color)
            .frame(width: particle.size, height: particle.size * 0.6)
            .rotationEffect(.degrees(currentRotation))
            .position(x: particle.x, y: particle.y + offsetY)
            .opacity(opacity)
            .onAppear {
                withAnimation(
                    .easeIn(duration: 3)
                    .delay(particle.delay)
                ) {
                    offsetY = 800
                    opacity = 0
                }
                
                withAnimation(
                    .linear(duration: 2)
                    .repeatForever(autoreverses: false)
                ) {
                    currentRotation = particle.rotation + 360
                }
            }
    }
}
