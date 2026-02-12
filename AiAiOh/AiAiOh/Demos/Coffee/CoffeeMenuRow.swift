//
//  CoffeeMenuRow.swift
//  AiAiOh
//  2/11/26
//  Individual menu item row
//

import SwiftUI

// MARK: - Coffee Menu Row

/// Displays a single menu item with name and price
struct CoffeeMenuRow: View {
    
    let item: CoffeeMenuItem
    
    var body: some View {
        HStack(alignment: .bottom) {
            // Drink name
            Text(item.name)
                .font(.system(size: 13, weight: .light, design: .default))
                .foregroundStyle(.primary)
            
            Spacer()
            
            // Price
            Text(item.price)
                .font(.system(size: 13, weight: .light, design: .monospaced))
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 6)
    }
}
