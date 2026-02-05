//
//  DemoModel.swift
//  AiAiOh
//
//  2/4/26
//

import Foundation
import SwiftUI

// MARK: - Demo Model

/// Represents a single demo in the app
struct Demo: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let destination: AnyView
    let date: String // Format: "020426"
}
