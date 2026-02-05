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
}
