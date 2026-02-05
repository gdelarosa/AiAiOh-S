//
//  InfoFilesRow.swift
//  AiAiOh
//  2/5/26
//  Horizontal scrolling row of info files
//

import SwiftUI

// MARK: - Info Files Row

/// Horizontal scrolling row displaying info file cards
struct InfoFilesRow: View {
    
    let files: [InfoFile]
    @Binding var selectedFile: InfoFile?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Title label
            Text("Concept Vault")
                .font(.system(size: 13, weight: .regular, design: .default))
                .foregroundStyle(.secondary)
                .padding(.leading, 24)
            
            // Horizontal scroll of files
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(files) { file in
                        InfoFileCard(file: file) {
                            selectedFile = file
                        }
                    }
                }
                .padding(.horizontal, 24)
            }
            
            // Divider line
            Rectangle()
                .fill(Color(.separator))
                .frame(height: 0.5)
                .padding(.horizontal, 24)
                .padding(.top, 8)
        }
    }
}
