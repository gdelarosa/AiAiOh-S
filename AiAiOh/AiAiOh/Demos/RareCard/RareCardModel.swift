//
//  RareCardModel.swift
//  AiAiOh
//  2/6/26
//  Data model for rare holographic card
//

import SwiftUI

// MARK: - Card Model

/// Represents a rare collectible card
struct CardData {
    let name: String
    let category: String
    let hp: Int
    let description: String
    let stats: CardStats
    let abilities: [Ability]
    let rarity: CardRarity
}

// MARK: - Card Stats

struct CardStats {
    let size: String
    let element: String
    let weakness: String
    let resistance: String
    let level: Int
    let number: Int
}

// MARK: - Ability

struct Ability {
    let name: String
    let energyCost: Int
    let description: String
}

// MARK: - Card Rarity

enum CardRarity {
    case common
    case uncommon
    case rare
    case ultraRare
    
    var gradientColors: [Color] {
        switch self {
        case .common:
            return [.gray, .white]
        case .uncommon:
            return [.green.opacity(0.3), .mint]
        case .rare:
            return [.cyan, .green, .yellow, .green, .cyan]
        case .ultraRare:
            return [.purple, .blue, .cyan, .green, .yellow, .orange, .pink]
        }
    }
}

// MARK: - Sample Data

extension CardData {
    static let lumpo = CardData(
        name: "Lumpo",
        category: "Blob Knight",
        hp: 35,
        description: "A cheerful guardian made of pure joy and determination. Lumpo protects the Candy Meadows with unwavering optimism.",
        stats: CardStats(
            size: "3'2\"",
            element: "Grass",
            weakness: "Fire",
            resistance: "Water",
            level: 8,
            number: 42
        ),
        abilities: [
            Ability(
                name: "Jelly Shield",
                energyCost: 1,
                description: "Lumpo's squishy body absorbs incoming attacks and bounces them back with a giggle."
            ),
            Ability(
                name: "Sparkle Sword",
                energyCost: 2,
                description: "Swings the enchanted blade, creating a cascade of magical sparkles that dazzle opponents."
            )
        ],
        rarity: .rare
    )
}
