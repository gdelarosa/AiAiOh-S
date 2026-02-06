//
//  InstructionLabelView.swift
//  AiAiOh
//  2/6/26
//  
//

import SwiftUI

// MARK: - Instruction Label

struct InstructionLabel: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundStyle(.green.opacity(0.6))
            
            Text(text)
                .font(.system(size: 11, weight: .light, design: .default))
                .foregroundStyle(.green.opacity(0.6))
        }
    }
}
