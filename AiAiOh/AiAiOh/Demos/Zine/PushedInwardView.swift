//
//  PushedInwardView.swift
//  AiAiOh
//  2/6/26
//  Animated paper visualization showing the cross/diamond shape when pushing ends inward
//

import SwiftUI

// MARK: - Pushed Inward View

/// Displays the paper forming a cross/diamond shape as the ends are pushed together
struct PushedInwardView: View {
    
    let size: CGSize
    let progress: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            let centerX = geometry.size.width / 2
            let centerY = geometry.size.height / 2
            let armLength = geometry.size.width * 0.35
            let spread = (1 - progress) * 40 + 10
            
            ZStack {
                // Four arms of the cross/diamond shape
                ForEach(0..<4, id: \.self) { index in
                    paperArm(
                        index: index,
                        armLength: armLength,
                        spread: spread,
                        center: CGPoint(x: centerX, y: centerY)
                    )
                }
            }
        }
        .shadow(color: .black.opacity(0.1), radius: 6, x: 0, y: 3)
    }
    
    // MARK: - Paper Arm
    
    private func paperArm(
        index: Int,
        armLength: CGFloat,
        spread: CGFloat,
        center: CGPoint
    ) -> some View {
        let angle = Double(index) * 90.0 + (progress * 15)
        
        return PaperArmShape()
            .fill(
                LinearGradient(
                    colors: [Color.white, Color(white: 0.95)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(width: armLength, height: size.height * 0.4)
            .overlay(
                PaperArmShape()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .rotationEffect(.degrees(angle))
            .offset(
                x: cos(angle * .pi / 180) * spread,
                y: sin(angle * .pi / 180) * spread
            )
            .position(x: center.x, y: center.y)
    }
}

// MARK: - Paper Arm Shape

/// Simple rounded rectangle shape for the paper arms
struct PaperArmShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRoundedRect(
            in: rect,
            cornerSize: CGSize(width: 2, height: 2)
        )
        return path
    }
}
