//
//  RamenMenuItem.swift
//  AiAiOh
//  2/4/26
//  Model representing a menu item from the ramen machine
//

import Foundation

/// Represents a single ramen menu item with bilingual names and dual-currency pricing
struct RamenMenuItem: Identifiable, Equatable {
    let id = UUID()
    let nameJP: String
    let nameEN: String
    let priceUSD: String
    let priceJPY: String
    
    static func == (lhs: RamenMenuItem, rhs: RamenMenuItem) -> Bool {
        lhs.id == rhs.id
    }
}
