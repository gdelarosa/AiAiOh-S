//
//  RamenMenuView.swift
//  AiAiOh
//  2/4/26
//

import SwiftUI

struct RamenMenuView: View {
    @Binding var showEnglish: Bool
    let onItemTapped: (RamenMenuItem) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(RamenMenuData.items) { item in
                    RamenMenuItemRow(item: item, showEnglish: showEnglish, onTap: {
                        onItemTapped(item)
                    })
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
        }
        .background(Color.white)
    }
}

struct RamenMenuItemRow: View {
    let item: RamenMenuItem
    let showEnglish: Bool
    let onTap: () -> Void
    
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
                    .foregroundColor(.black.opacity(0.8))
                    .overlay(
                        // Anime flash effect
                        Text(showEnglish ? item.nameEN : item.nameJP)
                            .font(.system(size: 11, weight: .light, design: .default))
                            .kerning(1.5)
                            .foregroundColor(.white)
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
                    .foregroundColor(.black.opacity(0.6))
                
                // Spacer between prices
                Text("  /  ")
                    .font(.system(size: 11, weight: .ultraLight))
                    .foregroundColor(.black.opacity(0.3))
                
                // Price in JPY
                Text(item.priceJPY)
                    .font(.system(size: 11, weight: .ultraLight, design: .monospaced))
                    .kerning(1)
                    .foregroundColor(.black.opacity(0.6))
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 8)
            .background(
                // Japanese highlighter effect
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(red: 1.0, green: 0.92, blue: 0.23))
                    .opacity(highlightOpacity * 0.6)
                    .blur(radius: 0.5)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
