//
//  RamenMenuItems.swift
//  AiAiOh
//  2/4/26
//  A 3D ramen machine demo 
//

import SwiftUI

struct RamenMachineView: View {
    @State private var rotation: Float = 0
    @State private var showEnglish: Bool = false
    @State private var shouldSpin: Bool = false
    @State private var selectedItem: RamenMenuItem? = nil
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // 3D Vending Machine and Price Label Container
                HStack(spacing: 0) {
                    // 3D Vending Machine
                    SceneKitView(
                        modelName: "Ramen_Vending_Machine",
                        rotation: $rotation,
                        shouldSpin: $shouldSpin
                    )
                    .frame(width: selectedItem == nil ? geometry.size.width : geometry.size.width * 0.65)
                    
                    // Price Label (appears when item selected)
                    if let item = selectedItem {
                        VStack(spacing: 8) {
                            Text("Total Cost")
                                .font(.system(size: 10, weight: .light, design: .default))
                                .kerning(1.5)
                                .foregroundStyle(.black.opacity(0.5))
                                .textCase(.uppercase)
                            
                            VStack(spacing: 4) {
                                Text(showEnglish ? item.nameEN : item.nameJP)
                                    .font(.system(size: 13, weight: .medium, design: .default))
                                    .kerning(1)
                                    .foregroundStyle(.black.opacity(0.8))
                                    .multilineTextAlignment(.center)
                                    .lineLimit(2)
                                
                                Text(item.priceUSD)
                                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                                    .kerning(0.5)
                                    .foregroundStyle(.black)
                                
                                Text(item.priceJPY)
                                    .font(.system(size: 14, weight: .semibold, design: .monospaced))
                                    .kerning(0.5)
                                    .foregroundStyle(.black.opacity(0.6))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 8)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                }
                .frame(height: geometry.size.height * 0.55)
                .animation(.spring(response: 0.5, dampingFraction: 0.75), value: selectedItem)
                
                // Ramen Menu (40% of available space)
                RamenMenuView(showEnglish: $showEnglish, onItemTapped: { item in
                    selectedItem = item
                    triggerSpin()
                })
                    .frame(height: geometry.size.height * 0.45)
            }
            .padding(.top, -20)
        }
        .ignoresSafeArea(.keyboard)
        .background(Color.white)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.light, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("ラーメン自販機")
                    .font(.system(size: 14, weight: .light, design: .default))
                    .kerning(2)
                    .foregroundStyle(.black.opacity(0.7))
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        showEnglish.toggle()
                    }
                }) {
                    Text(showEnglish ? "日本語" : "English")
                        .font(.system(size: 11, weight: .light, design: .default))
                        .kerning(1.5)
                        .foregroundStyle(.black.opacity(0.7))
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private func triggerSpin() {
        shouldSpin = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            shouldSpin = false
        }
    }
}
