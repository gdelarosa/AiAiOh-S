//
//  RamenMenuItemRow.swift
//  AiAiOh
//
//  Created on 2/4/26
//

import SwiftUI

struct RamenMenuItemRow: View {
    let item: RamenMenuItem
    let showEnglish: Bool
    let onTap: () -> Void
    
    @Environment(\.colorScheme) private var colorScheme
    @State private var flashOpacity: Double = 0
    @State private var highlightOpacity: Double = 0
    
    var body: some View {
        Button(action: {
            // Trigger highlight effect
            withAnimation(.easeOut(duration: 0.15)) {
                highlightOpacity = 1.0
            }
            withAnimation(.easeOut(duration: 0.6).delay(0.15)) {
                highlightOpacity = 0
            }
            onTap()
        }) {
            HStack(alignment: .center, spacing: 0) {
                // Name (Japanese or English)
                Text(showEnglish ? item.nameEN : item.nameJP)
                    .font(.system(size: 11, weight: .light, design: .default))
                    .kerning(1.5)
                    .foregroundStyle(.secondary)
                    .overlay(
                        // Anime flash effect
                        Text(showEnglish ? item.nameEN : item.nameJP)
                            .font(.system(size: 11, weight: .light, design: .default))
                            .kerning(1.5)
                            .foregroundStyle(.secondary)
                            .opacity(flashOpacity)
                            .blendMode(.plusLighter)
                    )
                    .onChange(of: showEnglish) { oldValue, newValue in
                        // Trigger anime flash
                        withAnimation(.easeOut(duration: 0.1)) {
                            flashOpacity = 1.0
                        }
                        withAnimation(.easeOut(duration: 0.4).delay(0.1)) {
                            flashOpacity = 0
                        }
                    }
                
                Spacer()
                
                // Price in USD
                Text(item.priceUSD)
                    .font(.system(size: 11, weight: .ultraLight, design: .monospaced))
                    .kerning(1)
                    .foregroundStyle(.secondary)
                
                // Spacer between prices
                Text("  /  ")
                    .font(.system(size: 11, weight: .ultraLight))
                    .foregroundStyle(.secondary)
                
                // Price in JPY
                Text(item.priceJPY)
                    .font(.system(size: 11, weight: .ultraLight, design: .monospaced))
                    .kerning(1)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .background(
                // Japanese highlighter effect - adapts to color scheme
                RoundedRectangle(cornerRadius: 2)
                    .fill(highlightColor)
                    .opacity(highlightOpacity * 0.6)
                    .blur(radius: 0.5)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // Adaptive highlight color based on color scheme
    private var highlightColor: Color {
        colorScheme == .dark
            ? Color(red: 1.0, green: 0.85, blue: 0.0) // Slightly deeper yellow for dark mode
            : Color(red: 1.0, green: 0.92, blue: 0.23) // Classic highlighter yellow for light mode
    }
}
