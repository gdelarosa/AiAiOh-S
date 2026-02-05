//
//  BubbleWrapDemoView.swift
//  AiAiOh
//
//  Interactive bubble wrap demo with hyper-realistic PBR rendering
//

import SwiftUI

struct BubbleWrapDemoView: View {
    @State private var bubbleGrid = BubbleGrid()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background image
                Image("flowers")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                
                // Bubble wrap overlay
                BubbleWrapMetalView(bubbleGrid: bubbleGrid, viewSize: geometry.size)
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { value in
                        bubbleGrid.popBubbleAt(point: value.location)
                    }
            )
            .onAppear {
                bubbleGrid.initializeGrid(for: geometry.size)
            }
            .onChange(of: geometry.size) { _, newSize in
                bubbleGrid.initializeGrid(for: newSize)
            }
        }
        .ignoresSafeArea()
        .navigationTitle("Bubble Wrap")
        .navigationBarTitleDisplayMode(.inline)
    }
}
