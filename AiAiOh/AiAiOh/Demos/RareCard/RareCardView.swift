//
//  RareCardView.swift
//  AiAiOh
//  2/6/26
//  Holographic card component with animated gradient effects
//

import SwiftUI
internal import Combine

// MARK: - Rare Card View

/// Displays a holographic collectible card with retro aesthetic
struct RareCardView: View {
    
    let card: CardData
    
    @State private var rotation: Double = 0
    @State private var gradientPhase: Double = 0
    
    // Animation timer
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Card background with holographic effect
            RoundedRectangle(cornerRadius: 20)
                .fill(.black)
                .overlay {
                    // Animated holographic gradient
                    AnimatedGradientView(
                        colors: card.rarity.gradientColors,
                        phase: gradientPhase
                    )
                    .opacity(0.3)
                    .blendMode(.screen)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                }
                .overlay {
                    // Scanline effect
                    ScanlineOverlay()
                        .blendMode(.overlay)
                        .opacity(0.15)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            
            // Card content
            VStack(spacing: 0) {
                // Header
                cardHeader
                
                // Main illustration area with wireframe
                illustrationArea
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                // Character info
                characterInfo
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                
                // Abilities section
                abilitiesSection
                    .padding(.horizontal, 16)
                
                // Bottom stats
                bottomStats
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
            }
        }
        .frame(width: 320, height: 450)
        .shadow(color: .green.opacity(0.5), radius: 20, x: 0, y: 10)
        .rotation3DEffect(
            .degrees(rotation),
            axis: (x: 0, y: 1, z: 0)
        )
        .onReceive(timer) { _ in
            withAnimation(.linear(duration: 0.05)) {
                gradientPhase += 0.02
                if gradientPhase > 1 {
                    gradientPhase = 0
                }
            }
        }
    }
    
    // MARK: - Card Header
    
    private var cardHeader: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                // Category and Name
                VStack(alignment: .leading, spacing: 2) {
                    Text(card.category)
                        .font(.system(size: 10, weight: .regular, design: .default))
                        .foregroundStyle(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .overlay {
                            RoundedRectangle(cornerRadius: 0)
                                .stroke(.green, lineWidth: 1.5)
                        }
                    
                    Text(card.name)
                        .font(.system(size: 28, weight: .bold, design: .default))
                        .foregroundStyle(.green)
                        .tracking(1)
                }
                
                Spacer()
                
                // HP
                HStack(spacing: 8) {
                    Text("\(card.hp) HP")
                        .font(.system(size: 24, weight: .bold, design: .default))
                        .foregroundStyle(.green)
                    
                    // Energy symbol - hexagon instead of star
                    HexagonShape()
                        .fill(.green)
                        .frame(width: 28, height: 28)
                        .overlay {
                            Image(systemName: "bolt.fill")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundStyle(.black)
                        }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
            
            // Divider
            Rectangle()
                .fill(.green)
                .frame(height: 2)
                .padding(.top, 8)
        }
    }
    
    // MARK: - Illustration Area
    
    private var illustrationArea: some View {
        ZStack {
            // Border frame
            Rectangle()
                .stroke(.green, lineWidth: 2)
            
            // Wireframe landscape background
            WireframeBackground()
                .padding(4)
        }
        .frame(height: 200)
    }
    
    // MARK: - Character Info
    
    private var characterInfo: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(.green)
                .frame(height: 1)
            
            Text("Creature Type: \(card.category) · Size: \(card.stats.size)")
                .font(.system(size: 9, weight: .regular, design: .default))
                .foregroundStyle(.green)
                .padding(.vertical, 6)
            
            Rectangle()
                .fill(.green)
                .frame(height: 1)
        }
    }
    
    // MARK: - Abilities Section
    
    private var abilitiesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Array(card.abilities.enumerated()), id: \.offset) { index, ability in
                HStack(alignment: .top, spacing: 8) {
                    // Energy cost indicators - hexagons
                    HStack(spacing: 4) {
                        ForEach(0..<ability.energyCost, id: \.self) { _ in
                            HexagonShape()
                                .fill(.green)
                                .frame(width: 20, height: 20)
                                .overlay {
                                    Image(systemName: "bolt.fill")
                                        .font(.system(size: 8, weight: .bold))
                                        .foregroundStyle(.black)
                                }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(ability.name)
                            .font(.system(size: 14, weight: .bold, design: .default))
                            .foregroundStyle(.green)
                        
                        Text(ability.description)
                            .font(.system(size: 9, weight: .regular, design: .default))
                            .foregroundStyle(.green)
                            .lineSpacing(2)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Bottom Stats
    
    private var bottomStats: some View {
        VStack(spacing: 8) {
            HStack(spacing: 0) {
                // Weakness
                StatBox(
                    title: "weakness",
                    icon: "flame.fill",
                    value: card.stats.weakness
                )
                
                Rectangle()
                    .fill(.green)
                    .frame(width: 1)
                
                // Resistance
                StatBox(
                    title: "resistance",
                    icon: "drop.fill",
                    value: card.stats.resistance
                )
                
                Rectangle()
                    .fill(.green)
                    .frame(width: 1)
                
                // Energy cost
                StatBox(
                    title: "energy cost",
                    icon: "",
                    value: ""
                )
            }
            .frame(height: 50)
            .overlay {
                Rectangle()
                    .stroke(.green, lineWidth: 1.5)
            }
            
            // Description
            Text(card.description)
                .font(.system(size: 8, weight: .regular, design: .default))
                .foregroundStyle(.green)
                .multilineTextAlignment(.leading)
                .lineSpacing(2)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Level and number
            HStack {
                Text("LV.\(card.stats.level)")
                    .font(.system(size: 9, weight: .bold, design: .default))
                    .foregroundStyle(.green)
                
                Spacer()
                
                Text("#\(card.stats.number)")
                    .font(.system(size: 9, weight: .bold, design: .default))
                    .foregroundStyle(.green)
            }
        }
    }
}
