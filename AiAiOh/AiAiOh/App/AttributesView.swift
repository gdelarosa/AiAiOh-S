//
//  AttributesView.swift
//  AiAiOh
//
//  2/4/26
//

import SwiftUI

// MARK: - Attributes View

struct AttributesView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Text("Thank you for exploring these demos.")
                    .font(.system(size: 15, weight: .light, design: .default))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .navigationTitle("Thank You")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 15, weight: .light, design: .default))
                }
            }
        }
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}
