//
//  InfoFileModel.swift
//  AiAiOh
//  2/5/26
//  Model for information files
//

import Foundation
import SwiftUI

// MARK: - Info File Model

/// Represents an information file/document
struct InfoFile: Identifiable {
    let id = UUID()
    let title: String
    let markdownContent: String
    let paperIcon: String
    
    /// Initialize with random paper icon selection
    init(title: String, markdownContent: String) {
        self.title = title
        self.markdownContent = markdownContent
        // Randomly select from paper1, paper2, paper3, paper4
        self.paperIcon = "paper\(Int.random(in: 1...4))"
    }
}
