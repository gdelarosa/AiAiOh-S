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
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            // Use the file's randomly assigned paper icon
            Image(file.paperIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 80)
                .scaleEffect(isPressed ? 0.92 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    isPressed = true
                }
                .onEnded { _ in
                    isPressed = false
                }
        )
    }
}
