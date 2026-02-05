//
//  InfoFileCard.swift
//  AiAiOh
//  2/5/26
//  Card component for displaying info file icons
//

import SwiftUI

// MARK: - Info File Card

/// A card displaying a single info file icon
struct InfoFileCard: View {
    
    let file: InfoFile
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            // Paper icon only
            Image("paper1")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 80)
        }
        .buttonStyle(.plain)
    }
}
