//
//  CoffeeMenuModel.swift
//  AiAiOh
//  2/11/26
//  Data model for coffee menu demo
//

import Foundation

// MARK: - Coffee Menu Model

/// Model representing coffee menu items
struct CoffeeMenuItem: Identifiable {
    let id = UUID()
    let name: String
    let price: String
    let category: MenuCategory
    
    enum MenuCategory {
        case hot
        case iced
    }
}

// MARK: - Menu Data

struct CoffeeMenuData {
    
    /// Hot coffee drinks
    static let hotDrinks: [CoffeeMenuItem] = [
        CoffeeMenuItem(name: "X/SPE3SS0", price: "$3.50", category: .hot),
        CoffeeMenuItem(name: "GO TO-Z", price: "$3.75", category: .hot),
        CoffeeMenuItem(name: "GOLDEN EYE", price: "$4.25", category: .hot),
        CoffeeMenuItem(name: "JUST COFFEE", price: "$4.50", category: .hot),
        CoffeeMenuItem(name: "BUZZ NEW YEAR", price: "$4.75", category: .hot),
        CoffeeMenuItem(name: "FLAT TIRED", price: "$4.75", category: .hot),
        CoffeeMenuItem(name: "CAFE DE OLLA", price: "$4.50", category: .hot),
        CoffeeMenuItem(name: "BAINES BAINES", price: "$5.25", category: .hot)
    ]
    
    /// Iced coffee drinks
    static let icedDrinks: [CoffeeMenuItem] = [
        CoffeeMenuItem(name: "ICED X/SPE3SS0", price: "$4.00", category: .iced),
        CoffeeMenuItem(name: "ICED GOLDEN EYE", price: "$4.25", category: .iced),
        CoffeeMenuItem(name: "JUST ICED COFFEE", price: "$5.25", category: .iced),
        CoffeeMenuItem(name: "COLD BREW", price: "$4.75", category: .iced),
        CoffeeMenuItem(name: "BEYOND COLD BREW", price: "$5.50", category: .iced)
    ]
}
