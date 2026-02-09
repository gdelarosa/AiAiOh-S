//
//  TextWeightGauge.swift
//  AiAiOh
//  2/9/26
//  Animated semicircular gauge for total word weight display
//

import SwiftUI

// MARK: - Weight Gauge

/// Animated arc gauge that visualizes the total weight of a word
struct TextWeightGauge: View {
    
    let totalWeight: Int
    let label: String
    let isVisible: Bool
    
    @State private var displayedWeight: Int = 0
    
    /// Normalized progress (0.0 to 1.0) capped at ~100 for visual range
    private var progress: Double {
        min(Double(totalWeight) / 100.0, 1.0)
    }
    
    /// Indigo-to-blue gradient — bold but refined
    private var gaugeGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(hue: 0.62, saturation: 0.25, brightness: 0.88),  // Soft periwinkle
                Color(hue: 0.65, saturation: 0.50, brightness: 0.80),  // Medium indigo
                Color(hue: 0.68, saturation: 0.65, brightness: 0.70),  // Rich indigo
                Color(hue: 0.72, saturation: 0.70, brightness: 0.58)   // Deep violet
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    var body: some View {
        ZStack {
            // Track
            Arc(startAngle: .degrees(150), endAngle: .degrees(390))
                .stroke(
                    Color(.systemFill).opacity(0.10),
                    style: StrokeStyle(lineWidth: 7, lineCap: .round)
                )
                .frame(width: 150, height: 150)
            
            // Fill
            Arc(
                startAngle: .degrees(150),
                endAngle: .degrees(150 + (isVisible ? progress * 240 : 0))
            )
            .stroke(
                gaugeGradient,
                style: StrokeStyle(lineWidth: 7, lineCap: .round)
            )
            .frame(width: 150, height: 150)
            .animation(
                .spring(response: 1.0, dampingFraction: 0.72),
                value: isVisible
            )
            
            // Center readout
            VStack(spacing: 1) {
                Text("\(displayedWeight)")
                    .font(.system(size: 40, weight: .thin, design: .rounded))
                    .foregroundStyle(.primary)
                    .monospacedDigit()
                
                Text(label.uppercased())
                    .font(.system(size: 9, weight: .medium))
                    .tracking(3)
                    .foregroundStyle(.secondary.opacity(0.6))
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeOut(duration: 0.3).delay(0.6), value: isVisible)
            }
            .offset(y: -6)
        }
        .frame(width: 170, height: 110)
        .onChange(of: isVisible) { _, visible in
            if visible { animateCounter() }
            else { displayedWeight = 0 }
        }
        .onChange(of: totalWeight) { _, _ in
            if isVisible { animateCounter() }
        }
    }
    
    private func animateCounter() {
        displayedWeight = 0
        let target = totalWeight
        guard target > 0 else { return }
        let stepDuration = min(0.5 / Double(target), 0.03)
        
        for i in 1...target {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * stepDuration) {
                displayedWeight = i
            }
        }
    }
}

// MARK: - Arc Shape

struct Arc: Shape {
    var startAngle: Angle
    var endAngle: Angle
    
    var animatableData: Double {
        get { endAngle.degrees }
        set { endAngle = .degrees(newValue) }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        path.addArc(
            center: center, radius: radius,
            startAngle: startAngle, endAngle: endAngle,
            clockwise: false
        )
        return path
    }
}
