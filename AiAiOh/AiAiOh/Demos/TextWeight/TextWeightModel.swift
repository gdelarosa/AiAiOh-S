//
//  TextWeightModel.swift
//  AiAiOh
//  2/9/26
//  Data model and calculation engine for the Text Weight demo
//

import Foundation

// MARK: - Letter Weight Result

/// Represents a single letter and its calculated weight
struct LetterWeight: Identifiable {
    let id = UUID()
    let letter: Character
    let baseWeight: Int
}

// MARK: - Weight Modifiers

/// Breakdown of all modifier bonuses applied to a word
struct WeightModifiers {
    let vowelBonus: Int
    let repetitionBonus: Int
    let rareLetterBonus: Int
    
    var total: Int {
        vowelBonus + repetitionBonus + rareLetterBonus
    }
}

// MARK: - Word Weight Result

/// Complete result of a word weight calculation
struct WordWeightResult: Identifiable {
    let id = UUID()
    let input: String
    let normalized: String
    let totalWeight: Int
    let baseWeight: Int
    let modifiers: WeightModifiers
    let breakdown: [LetterWeight]
    
    /// Interpretation label based on total weight
    var label: String {
        switch totalWeight {
        case 0...20: return "Light"
        case 21...40: return "Medium"
        case 41...60: return "Heavy"
        default: return "Dense"
        }
    }
}

// MARK: - Text Weight Calculator

/// Deterministic calculator for English word weights
struct TextWeightCalculator {
    
    // MARK: - Constants
    
    /// Base weights for each letter A–Z
    static let letterWeights: [Character: Int] = [
        "A": 8, "B": 6, "C": 5, "D": 7, "E": 9,
        "F": 5, "G": 7, "H": 3, "I": 4, "J": 3,
        "K": 6, "L": 4, "M": 8, "N": 5, "O": 8,
        "P": 6, "Q": 9, "R": 5, "S": 4, "T": 6,
        "U": 5, "V": 4, "W": 7, "X": 8, "Y": 5,
        "Z": 6
    ]
    
    /// Vowels for density bonus calculation
    static let vowels: Set<Character> = ["A", "E", "I", "O", "U", "Y"]
    
    /// Rare letters that add density bonus
    static let rareLetters: Set<Character> = ["Q", "X", "Z", "J"]
    
    // MARK: - Calculation
    
    /// Calculate the full weight result for a given word
    static func calculate(_ word: String) -> WordWeightResult {
        let normalized = word.uppercased().filter { $0.isLetter }
        
        guard !normalized.isEmpty else {
            return WordWeightResult(
                input: word,
                normalized: "",
                totalWeight: 0,
                baseWeight: 0,
                modifiers: WeightModifiers(vowelBonus: 0, repetitionBonus: 0, rareLetterBonus: 0),
                breakdown: []
            )
        }
        
        var baseWeight = 0
        var breakdown: [LetterWeight] = []
        var vowelCount = 0
        var rareBonus = 0
        
        for char in normalized {
            let weight = letterWeights[char] ?? 0
            baseWeight += weight
            breakdown.append(LetterWeight(letter: char, baseWeight: weight))
            
            if vowels.contains(char) {
                vowelCount += 1
            }
            
            if rareLetters.contains(char) {
                rareBonus += 2
            }
        }
        
        let vowelBonus: Int
        switch vowelCount {
        case 1...2: vowelBonus = 0
        case 3...4: vowelBonus = 2
        default: vowelBonus = vowelCount >= 5 ? 5 : 0
        }
        
        var repetitionBonus = 0
        let chars = Array(normalized)
        for i in 1..<chars.count {
            if chars[i] == chars[i - 1] {
                repetitionBonus += 1
            }
        }
        
        let modifiers = WeightModifiers(
            vowelBonus: vowelBonus,
            repetitionBonus: repetitionBonus,
            rareLetterBonus: rareBonus
        )
        
        let totalWeight = baseWeight + modifiers.total
        
        return WordWeightResult(
            input: word,
            normalized: normalized,
            totalWeight: totalWeight,
            baseWeight: baseWeight,
            modifiers: modifiers,
            breakdown: breakdown
        )
    }
}
