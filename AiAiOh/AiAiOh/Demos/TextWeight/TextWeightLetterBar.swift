//
//  TextWeightLetterBar.swift
//  AiAiOh
//  2/9/26
//  Animated bar visualization for individual letter weights
//

import SwiftUI

// MARK: - Letter Bar

/// Animated horizontal bar showing a letter's weight contribution
struct TextWeightLetterBar: View {
    
    let letterWeight: LetterWeight
    let index: Int
    let isVisible: Bool
    let maxWeight: Int = 9
    
    /// Indigo spectrum — weight controls saturation and depth
    private var barColor: Color {
        let ratio = Double(letterWeight.baseWeight) / Double(maxWeight)
        return Color(
            hue: 0.64 + ratio * 0.08,
            saturation: 0.20 + ratio * 0.50,
            brightness: 0.88 - ratio * 0.22
        )
    }
    
    var body: some View {
        HStack(spacing: 0) {
            // Letter
            Text(String(letterWeight.letter))
                .font(.system(size: 15, weight: .light, design: .monospaced))
                .foregroundStyle(.primary.opacity(0.8))
                .frame(width: 22, alignment: .leading)
            
            // Bar
            GeometryReader { geo in
                let targetWidth = max(
                    geo.size.width * CGFloat(letterWeight.baseWeight) / CGFloat(maxWeight),
                    4
                )
                
                ZStack(alignment: .leading) {
                    // Track
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color(.systemFill).opacity(0.08))
                        .frame(height: 4)
                    
                    // Fill
                    RoundedRectangle(cornerRadius: 2)
                        .fill(barColor)
                        .frame(width: isVisible ? targetWidth : 0, height: 4)
                        .animation(
                            .spring(response: 0.55, dampingFraction: 0.75)
                                .delay(Double(index) * 0.05),
                            value: isVisible
                        )
                }
                .frame(maxHeight: .infinity, alignment: .center)
            }
            .frame(height: 24)
            .padding(.leading, 10)
            .padding(.trailing, 8)
            
            // Weight number
            Text("\(letterWeight.baseWeight)")
                .font(.system(size: 12, weight: .light, design: .monospaced))
                .foregroundStyle(.secondary.opacity(0.7))
                .frame(width: 16, alignment: .trailing)
        }
        .opacity(isVisible ? 1 : 0)
        .offset(x: isVisible ? 0 : -12)
        .animation(
            .smooth(duration: 0.35).delay(Double(index) * 0.05),
            value: isVisible
        )
    }
}
