//
//  DemoRow.swift
//  AiAiOh
//  2/4/26
//

import SwiftUI

// MARK: - Demo Row

/// Individual row displaying demo information
struct DemoRow: View {
    let demo: Demo
    
    @State private var isPressed = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                // Left side - Title and Description
                VStack(alignment: .leading, spacing: 4) {
                    Text(demo.title)
                        .font(.system(size: 16, weight: .light, design: .default))
                        .foregroundStyle(.primary)
                    
                    Text(demo.description)
                        .font(.system(size: 11, weight: .light, design: .default))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                // Right side - Date and Quarter
                VStack(alignment: .trailing, spacing: 2) {
                    Text(demo.date)
                        .font(.system(size: 11, weight: .light, design: .monospaced))
                        .foregroundStyle(.secondary)
                    
                    Text(demo.quarter)
                        .font(.system(size: 9, weight: .light, design: .monospaced))
                        .foregroundStyle(.secondary.opacity(0.6))
                }
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.secondarySystemBackground))
                    .opacity(isPressed ? 1 : 0)
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
            .contentShape(Rectangle())
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        isPressed = true
                    }
                    .onEnded { _ in
                        isPressed = false
                    }
            )
            
            // Minimal separator
            Rectangle()
                .fill(Color(.separator))
                .frame(height: 0.5)
        }
    }
}
