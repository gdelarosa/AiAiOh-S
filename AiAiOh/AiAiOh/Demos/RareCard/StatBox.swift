//
//  StatBox.swift
//  AiAiOh
//  2/6/26
//

import SwiftUI

// MARK: - Stat Box Component

struct StatBox: View {
    let title: String
    let icon: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.system(size: 8, weight: .regular, design: .default))
                .foregroundStyle(.green)
            
            HStack(spacing: 4) {
                if title == "energy cost" {
                    // Use hexagon for energy
                    HexagonShape()
                        .stroke(.green, lineWidth: 1.5)
                        .frame(width: 16, height: 16)
                } else {
                    Image(systemName: icon)
                        .font(.system(size: 12))
                        .foregroundStyle(.green)
                }
                
                if !value.isEmpty {
                    Text(value)
                        .font(.system(size: 10, weight: .bold, design: .default))
                        .foregroundStyle(.green)
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}
