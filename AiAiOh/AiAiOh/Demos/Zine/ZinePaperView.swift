//
//  ZinePaperView.swift
//  AiAiOh
//  2/6/26
//  Coordinator view for paper visualization in the zine folding tutorial
//

import SwiftUI

// MARK: - Zine Paper View

/// Renders the paper in its current fold state with animations
/// Delegates to individual paper state views based on the current step
struct ZinePaperView: View {
    
    let step: ZineFoldingStep
    @Binding var isAnimating: Bool
    
    // MARK: - Animation State
    
    @State private var cutProgress: CGFloat = 0
    @State private var pushProgress: CGFloat = 0
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            let size = calculatePaperSize(in: geometry)
            
            ZStack {
                // Main paper rendering
                paperView(size: size)
                    .frame(width: size.width, height: size.height)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
            }
        }
        .onChange(of: step.id) { _, newValue in
            animateToStep(newValue)
        }
        .onAppear {
            animateToStep(step.id)
        }
    }
    
    // MARK: - Paper Size Calculation
    
    private func calculatePaperSize(in geometry: GeometryProxy) -> CGSize {
        let maxWidth = geometry.size.width - 40
        let maxHeight = geometry.size.height - 40
        
        // Standard letter paper ratio (11:8.5 in landscape)
        let paperRatio: CGFloat = 11.0 / 8.5
        
        var width = maxWidth
        var height = width / paperRatio
        
        if height > maxHeight {
            height = maxHeight
            width = height * paperRatio
        }
        
        // Scale down based on fold state
        let scale = scaleForState(step.foldState)
        return CGSize(width: width * scale.width, height: height * scale.height)
    }
    
    private func scaleForState(_ state: ZineFoldingStep.FoldState) -> CGSize {
        switch state {
        case .flat, .unfoldedWithCreases, .unfoldedWithCut:
            return CGSize(width: 1.0, height: 1.0)
        case .foldedInHalfVertical, .foldedHorizontalHalf, .foldedLongWays:
            return CGSize(width: 0.5, height: 1.0)
        case .foldedInQuarters:
            return CGSize(width: 0.5, height: 0.5)
        case .foldedInEighths:
            return CGSize(width: 0.25, height: 0.5)
        case .cutCenter:
            return CGSize(width: 0.5, height: 1.0)
        case .pushedInward, .formingPages:
            return CGSize(width: 0.6, height: 0.8)
        case .completedZine:
            return CGSize(width: 0.3, height: 0.6)
        }
    }
    
    // MARK: - Paper View Router
    
    @ViewBuilder
    private func paperView(size: CGSize) -> some View {
        switch step.foldState {
        case .flat:
            FlatPaperView(size: size)
            
        case .foldedInHalfVertical:
            FoldedPaperView(size: size, foldDirection: .vertical, layers: 2)
            
        case .foldedInQuarters:
            FoldedPaperView(size: size, foldDirection: .both, layers: 4)
            
        case .foldedInEighths:
            FoldedPaperView(size: size, foldDirection: .vertical, layers: 8)
            
        case .unfoldedWithCreases:
            CreasedPaperView(size: size, showCut: false)
            
        case .foldedHorizontalHalf:
            FoldedPaperView(size: size, foldDirection: .horizontal, layers: 2)
            
        case .cutCenter:
            CutPaperView(size: size, cutProgress: cutProgress)
                .onAppear {
                    withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                        cutProgress = 1.0
                    }
                }
            
        case .unfoldedWithCut:
            CreasedPaperView(size: size, showCut: true)
            
        case .foldedLongWays:
            FoldedLongWaysView(size: size)
            
        case .pushedInward:
            PushedInwardView(size: size, progress: pushProgress)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0).delay(0.2)) {
                        pushProgress = 1.0
                    }
                }
            
        case .formingPages:
            FormingPagesView(size: size)
            
        case .completedZine:
            CompletedZineView(size: size)
        }
    }
    
    // MARK: - Animation
    
    private func animateToStep(_ stepId: Int) {
        // Reset animation states
        cutProgress = 0
        pushProgress = 0
        
        // Trigger new animations based on step
        if step.foldState == .cutCenter {
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                cutProgress = 1.0
            }
        } else if step.foldState == .pushedInward {
            withAnimation(.easeInOut(duration: 1.0).delay(0.2)) {
                pushProgress = 1.0
            }
        }
    }
}
