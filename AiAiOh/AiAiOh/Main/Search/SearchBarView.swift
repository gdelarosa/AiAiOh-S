//
//  SearchBarView.swift
//  AiAiOh
//  2/5/26
//  Search bar component for filtering demos by index tags
//

import SwiftUI

// MARK: - Search Bar View

struct SearchBarView: View {
    
    @Binding var searchText: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack(spacing: 8) {
            // Search icon
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14, weight: .light))
                .foregroundStyle(.secondary)
            
            // Text field
            TextField("Search index", text: $searchText)
                .font(.system(size: 14, weight: .light, design: .default))
                .focused($isFocused)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
            
            // Clear button
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14, weight: .light))
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
