//
//  RamenMenuView.swift
//  AiAiOh
//  2/4/26
//

import SwiftUI

struct RamenMenuView: View {
    @Binding var showEnglish: Bool
    let onItemTapped: (RamenMenuItem) -> Void
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(RamenMenuData.items) { item in
                    RamenMenuItemRow(item: item, showEnglish: showEnglish, onTap: {
                        onItemTapped(item)
                    })
                }
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 12)
        }
    }
}
