//
//  Bubble.swift
//  AiAiOh
//
//  Model representing a single bubble in the bubble wrap
//

import Foundation

struct Bubble: Identifiable {
    let id = UUID()
    var row: Int
    var col: Int
    var centerX: Float
    var centerY: Float
    var radius: Float
    var isPopped: Bool = false
    var popProgress: Float = 0.0 // 0 = unpopped, 1 = fully popped
    var popStartTime: Double = 0
    var imperfectionSeed: Float // For micro-surface variations
    var dent: Float // Subtle random dent amount
}
