//
//  DemoIndexView.swift
//  AiAiOh
//  2/5/26
//  Component to display index tags for a demo
//

import SwiftUI

// MARK: - Demo Index View

/// Displays the index tags for a demo in a compact format
struct DemoIndexView: View {
    
    let tags: [String]
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(tags.enumerated()), id: \.offset) { index, tag in
                Group {
                    Text(tag)
                        .font(.system(size: 9, weight: .light, design: .monospaced))
                        .foregroundStyle(.secondary.opacity(0.7))
                    
                    if index < tags.count - 1 {
                        Text("·")
                            .font(.system(size: 9, weight: .light))
                            .foregroundStyle(.secondary.opacity(0.5))
                    }
                }
            }
        }
    }
}
