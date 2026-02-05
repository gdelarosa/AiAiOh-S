//
//  AttributionRow.swift
//  AiAiOh
//  2/5/26
//  Attribution row containing data
//

import SwiftUI

// MARK: - Attribution Row

struct AttributionRow: View {
    let attribution: Attribution
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                // Title
                Text(attribution.title)
                    .font(.system(size: 16, weight: .light, design: .default))
                    .foregroundStyle(.primary)
                
                // Creator
                Text("by \(attribution.creator)")
                    .font(.system(size: 11, weight: .light, design: .default))
                    .foregroundStyle(.secondary)
                
                // Asset URL
                Link(destination: URL(string: attribution.url)!) {
                    Text(attribution.url)
                        .font(.system(size: 11, weight: .light, design: .monospaced))
                        .foregroundStyle(.blue)
                        .underline()
                }
                
                // License
                HStack(spacing: 4) {
                    Text("License:")
                        .font(.system(size: 11, weight: .light, design: .default))
                        .foregroundStyle(.secondary)
                    
                    if let licenseURL = attribution.licenseURL {
                        Link(destination: URL(string: licenseURL)!) {
                            Text(attribution.license)
                                .font(.system(size: 11, weight: .light, design: .default))
                                .foregroundStyle(.blue)
                                .underline()
                        }
                    } else {
                        Text(attribution.license)
                            .font(.system(size: 11, weight: .light, design: .default))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 20)
            
            // Minimal separator
            Rectangle()
                .fill(Color(.separator))
                .frame(height: 0.5)
        }
    }
}
