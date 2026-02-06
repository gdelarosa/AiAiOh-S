//
//  RareCardDemoView.swift
//  AiAiOh
//  2/6/26
//  Interactive rare holographic card demo with gesture controls
//

import SwiftUI

// MARK: - Rare Card Demo View

/// Main coordinator view for the rare card demo
struct RareCardDemoView: View {
    
    // MARK: - State
    
    @State private var rotationAngle: Double = 0
    @State private var cardScale: CGFloat = 1.0
    @State private var yOffset: CGFloat = 0
    
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Gesture State
    
    @GestureState private var dragOffset: CGFloat = 0
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.08),
                    Color(red: 0.1, green: 0.15, blue: 0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Subtle grid pattern
            GridPattern()
                .opacity(0.1)
                .ignoresSafeArea()
            
            VStack {
                // Close button
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundStyle(.green.opacity(0.7))
                            .symbolRenderingMode(.hierarchical)
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                }
                .padding(.top, 20)
                
                Spacer()
                
                // The card
                RareCardView(card: .lumpo)
                    .scaleEffect(cardScale)
                    .rotation3DEffect(
                        .degrees(rotationAngle),
                        axis: (x: 0, y: 1, z: 0),
                        perspective: 0.5
                    )
                    .offset(y: yOffset)
                    .gesture(
                        DragGesture()
                            .updating($dragOffset) { value, state, _ in
                                state = value.translation.width
                            }
                            .onChanged { value in
                                rotationAngle = value.translation.width / 5
                                yOffset = value.translation.height / 3
                            }
                            .onEnded { _ in
                                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                                    rotationAngle = 0
                                    yOffset = 0
                                }
                            }
                    )
                    .gesture(
                        MagnificationGesture()
                            .onChanged { value in
                                cardScale = value
                            }
                            .onEnded { _ in
                                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                    cardScale = 1.0
                                }
                            }
                    )
                
                Spacer()
                
                // Instructions
                VStack(spacing: 12) {
                    HStack(spacing: 20) {
                        InstructionLabel(icon: "hand.draw", text: "Drag to rotate")
                        InstructionLabel(icon: "magnifyingglass", text: "Pinch to zoom")
                    }
                    
                    Text("Holographic Rare Card · Canvas & QuartzCore")
                        .font(.system(size: 10, weight: .light, design: .monospaced))
                        .foregroundStyle(.green.opacity(0.5))
                }
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
    }
}
