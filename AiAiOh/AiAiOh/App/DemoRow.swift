//
//  DemoRow.swift
//  AiAiOh
//  2/4/2
//

import SwiftUI

// MARK: - Demo Row

/// Individual row displaying demo information
struct DemoRow: View {
    let demo: Demo
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                // Left side - Title and Description
                VStack(alignment: .leading, spacing: 4) {
                    Text(demo.title)
                        .font(.system(size: 16, weight: .light, design: .default))
                        .foregroundColor(.primary)
                    
                    Text(demo.description)
                        .font(.system(size: 11, weight: .light, design: .default))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                // Right side - Date
                Text(demo.date)
                    .font(.system(size: 11, weight: .light, design: .monospaced))
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 20)
            .contentShape(Rectangle()) // ← Add this line
            
            // Minimal separator
            Rectangle()
                .fill(Color.secondary.opacity(0.1))
                .frame(height: 0.5)
        }
    }
}
