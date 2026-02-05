//
//  InfoFileDetailView.swift
//  AiAiOh
//  2/5/26
//  Detail view for displaying info file markdown content
//

import SwiftUI

// MARK: - Info File Detail View

/// Popup view displaying the markdown content of an info file
struct InfoFileDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    let file: InfoFile
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Use SwiftUI's native markdown rendering
                    Text(.init(file.markdownContent))
                        .font(.system(size: 15, weight: .light, design: .default))
                        .foregroundStyle(.primary)
                        .textSelection(.enabled)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(24)
            }
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(file.title)
                        .font(.system(size: 14, weight: .light, design: .default))
                        .kerning(1)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 15, weight: .light, design: .default))
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}
