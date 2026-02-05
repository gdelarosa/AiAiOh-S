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
                
                // Right side - Date
                Text(demo.date)
                    .font(.system(size: 11, weight: .light, design: .monospaced))
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 20)
            .contentShape(Rectangle())
            
            // Minimal separator
            Rectangle()
                .fill(Color(.separator))
                .frame(height: 0.5)
        }
    }
}
