//
//  CoffeeDemoView.swift
//  AiAiOh
//  2/11/26
//  Minimal coffee menu with cocoa bean imagery
//

import SwiftUI

// MARK: - Coffee Demo View

struct CoffeeDemoView: View {
    
    @State private var contentOpacity: Double = 0
    @State private var beanScale: CGFloat = 0.7
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                
                // Top spacing
                Spacer()
                    .frame(height: 40)
                
                // Title
                Text("COFFEE")
                    .font(.system(size: 48, weight: .heavy, design: .default))
                    .foregroundStyle(.primary)
                    .kerning(2)
                    .padding(.bottom, 4)
                
                Text("godspeed")
                    .font(.system(size: 14, weight: .light, design: .default))
                    .italic()
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 32)
                
                // Cocoa bean image
                Image("cocoabean")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200)
                    .scaleEffect(beanScale)
                    .padding(.bottom, 40)
                
                // Hot drinks section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("+VERY HOT")
                            .font(.system(size: 11, weight: .medium, design: .monospaced))
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                    }
                    .padding(.bottom, 4)
                    
                    ForEach(CoffeeMenuData.hotDrinks) { item in
                        CoffeeMenuRow(item: item)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
                
                // Separator
                Rectangle()
                    .fill(Color(.separator).opacity(0.3))
                    .frame(height: 1)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                
                // Iced drinks section
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("+COLD COLD")
                            .font(.system(size: 11, weight: .medium, design: .monospaced))
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                    }
                    .padding(.bottom, 4)
                    
                    ForEach(CoffeeMenuData.icedDrinks) { item in
                        CoffeeMenuRow(item: item)
                    }
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 40)
                
                // Bottom spacing
                Spacer()
                    .frame(height: 20)
            }
            .opacity(contentOpacity)
        }
        .background(Color(.systemBackground))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Entrance animations
            withAnimation(.easeOut(duration: 0.6)) {
                contentOpacity = 1.0
            }
            
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                beanScale = 1.0
            }
        }
    }
}
