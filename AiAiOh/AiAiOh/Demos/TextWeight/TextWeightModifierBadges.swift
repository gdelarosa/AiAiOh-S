//
//  TextWeightModifierBadges.swift
//  AiAiOh
//  2/9/26
//  Animated badges displaying weight modifier bonuses
//

import SwiftUI

// MARK: - Modifier Badges

/// Row of animated badges showing active weight modifiers
struct TextWeightModifierBadges: View {
    
    let modifiers: WeightModifiers
    let isVisible: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            if modifiers.vowelBonus > 0 {
                ModifierBadge(
                    icon: "waveform.path",
                    label: "vowel",
                    value: "+\(modifiers.vowelBonus)",
                    delay: 0.0,
                    isVisible: isVisible
                )
            }
            
            if modifiers.repetitionBonus > 0 {
                ModifierBadge(
                    icon: "repeat",
                    label: "repeat",
                    value: "+\(modifiers.repetitionBonus)",
                    delay: 0.08,
                    isVisible: isVisible
                )
            }
            
            if modifiers.rareLetterBonus > 0 {
                ModifierBadge(
                    icon: "diamond",
                    label: "rare",
                    value: "+\(modifiers.rareLetterBonus)",
                    delay: 0.16,
                    isVisible: isVisible
                )
            }
            
            if modifiers.total == 0 {
                Text("no modifiers")
                    .font(.system(size: 11, weight: .light))
                    .foregroundStyle(.secondary.opacity(0.4))
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeOut(duration: 0.3).delay(0.2), value: isVisible)
            }
        }
    }
}

// MARK: - Modifier Badge

/// Individual animated badge — warm neutral tone, all badges share one palette
struct ModifierBadge: View {
    
    let icon: String
    let label: String
    let value: String
    let delay: Double
    let isVisible: Bool
    
    @State private var appeared = false
    
    /// Indigo neutral — matches gauge and bar palette
    private let badgeColor = Color(hue: 0.66, saturation: 0.45, brightness: 0.60)
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 8, weight: .medium))
            
            Text(label)
                .font(.system(size: 10, weight: .regular))
            
            Text(value)
                .font(.system(size: 10, weight: .semibold, design: .monospaced))
        }
        .foregroundStyle(badgeColor)
        .padding(.horizontal, 9)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(badgeColor.opacity(0.08))
        )
        .scaleEffect(appeared ? 1.0 : 0.6)
        .opacity(appeared ? 1 : 0)
        .onChange(of: isVisible) { _, newValue in
            withAnimation(.spring(response: 0.45, dampingFraction: 0.65).delay(delay)) {
                appeared = newValue
            }
        }
    }
}
