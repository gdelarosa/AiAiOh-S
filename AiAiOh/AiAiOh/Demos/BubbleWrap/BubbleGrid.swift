//
//  BubbleGrid.swift
//  AiAiOh
//
//  Manages the grid of bubbles and their state
//

import Foundation
import QuartzCore

@Observable
class BubbleGrid {
    var bubbles: [[Bubble]] = []
    var rows: Int = 0
    var cols: Int = 0
    var bubbleRadius: Float = 0
    var bubbleSpacing: Float = 0
    private let popDuration: Double = 0.35
    
    func initializeGrid(for size: CGSize) {
        // Calculate optimal bubble size for screen
        let targetBubbleSize: Float = 44.0 // Good tap target size
        bubbleRadius = targetBubbleSize / 2.0
        bubbleSpacing = targetBubbleSize * 1.08 // Slight gap for seams
        
        // Calculate grid dimensions
        cols = Int(Float(size.width) / bubbleSpacing) + 2
        rows = Int(Float(size.height) / bubbleSpacing) + 2
        
        // Offset for hexagonal packing
        let hexOffsetX = bubbleSpacing
        let hexOffsetY = bubbleSpacing * 0.866 // sqrt(3)/2 for hex packing
        
        bubbles = []
        
        for row in 0..<rows {
            var rowBubbles: [Bubble] = []
            let rowOffset = (row % 2 == 0) ? 0 : bubbleSpacing * 0.5
            
            for col in 0..<cols {
                let centerX = Float(col) * hexOffsetX + rowOffset
                let centerY = Float(row) * hexOffsetY
                
                let bubble = Bubble(
                    row: row,
                    col: col,
                    centerX: centerX,
                    centerY: centerY,
                    radius: bubbleRadius,
                    imperfectionSeed: Float.random(in: 0...1),
                    dent: Float.random(in: 0...0.08)
                )
                rowBubbles.append(bubble)
            }
            bubbles.append(rowBubbles)
        }
    }
    
    func popBubbleAt(point: CGPoint) {
        let tapX = Float(point.x)
        let tapY = Float(point.y)
        
        // Find the closest unpopped bubble to the tap point
        var closestDistance: Float = Float.greatestFiniteMagnitude
        var closestRow: Int = -1
        var closestCol: Int = -1
        
        for row in 0..<rows {
            for col in 0..<cols {
                let bubble = bubbles[row][col]
                if bubble.isPopped { continue }
                
                let dx = tapX - bubble.centerX
                let dy = tapY - bubble.centerY
                let distance = sqrt(dx * dx + dy * dy)
                
                if distance <= bubble.radius && distance < closestDistance {
                    closestDistance = distance
                    closestRow = row
                    closestCol = col
                }
            }
        }
        
        if closestRow >= 0 && closestCol >= 0 {
            bubbles[closestRow][closestCol].isPopped = true
            bubbles[closestRow][closestCol].popStartTime = CACurrentMediaTime()
        }
    }
    
    func popBubble(row: Int, col: Int) {
        guard row < rows && col < cols else { return }
        guard !bubbles[row][col].isPopped else { return }
        
        bubbles[row][col].isPopped = true
        bubbles[row][col].popStartTime = CACurrentMediaTime()
    }
    
    func updatePopAnimations() {
        let currentTime = CACurrentMediaTime()
        
        for row in 0..<rows {
            for col in 0..<cols {
                if bubbles[row][col].isPopped && bubbles[row][col].popProgress < 1.0 {
                    let elapsed = currentTime - bubbles[row][col].popStartTime
                    bubbles[row][col].popProgress = min(1.0, Float(elapsed / popDuration))
                }
            }
        }
    }
    
    // Pack bubble data for GPU
    func packBubbleData() -> [Float] {
        var data: [Float] = []
        for row in bubbles {
            for bubble in row {
                data.append(bubble.centerX)
                data.append(bubble.centerY)
                data.append(bubble.radius)
                data.append(bubble.popProgress)
                data.append(bubble.imperfectionSeed)
                data.append(bubble.dent)
                data.append(0) // padding
                data.append(0) // padding
            }
        }
        return data
    }
}
