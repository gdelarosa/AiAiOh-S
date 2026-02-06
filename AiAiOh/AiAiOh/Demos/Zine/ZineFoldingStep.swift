//
//  ZineFoldingStep.swift
//  AiAiOh
//  2/6/26
//  Model defining each step in the 8-page zine folding process
//

import SwiftUI

// MARK: - Zine Folding Step

/// Represents a single step in the zine folding tutorial
struct ZineFoldingStep: Identifiable, Equatable {
    let id: Int
    let title: String
    let instruction: String
    let foldState: FoldState
    let actionHint: String?
    let hintIcon: String?
    
    // MARK: - Fold State
    
    /// Describes the current state of the paper for rendering
    enum FoldState: Equatable {
        case flat                           // Step 1: Flat paper
        case foldedInHalfVertical           // Step 2: Folded in half vertically (hotdog)
        case foldedInQuarters               // Step 3: Folded again (now quarters)
        case foldedInEighths                // Step 4: Folded into eighths
        case unfoldedWithCreases            // Step 5: Unfolded showing crease lines
        case foldedHorizontalHalf           // Step 6: Folded in half horizontally
        case cutCenter                      // Step 7: Cut along center crease
        case unfoldedWithCut                // Step 8: Unfolded showing cut
        case foldedLongWays                 // Step 9: Fold long ways
        case pushedInward                   // Step 10: Push ends inward
        case formingPages                   // Step 11: Pages taking shape
        case completedZine                  // Step 12: Finished zine
    }
    
    // MARK: - All Steps
    
    /// Complete sequence of folding steps
    static let allSteps: [ZineFoldingStep] = [
        ZineFoldingStep(
            id: 0,
            title: "Start with Paper",
            instruction: "Begin with a standard sheet of paper (letter size or A4). Place it flat on your surface in landscape orientation.",
            foldState: .flat,
            actionHint: "Swipe to continue",
            hintIcon: "hand.draw"
        ),
        ZineFoldingStep(
            id: 1,
            title: "First Fold",
            instruction: "Fold the paper in half vertically, bringing the right edge to meet the left edge. Press firmly along the crease.",
            foldState: .foldedInHalfVertical,
            actionHint: "PRESS the fold",
            hintIcon: "arrow.down.to.line"
        ),
        ZineFoldingStep(
            id: 2,
            title: "Second Fold",
            instruction: "Fold in half again, bringing the folded edge to meet the open edges. You now have quarters.",
            foldState: .foldedInQuarters,
            actionHint: "PRESS again",
            hintIcon: "arrow.down.to.line"
        ),
        ZineFoldingStep(
            id: 3,
            title: "Third Fold",
            instruction: "Fold one more time to create eighths. Your paper should now be a small rectangle.",
            foldState: .foldedInEighths,
            actionHint: "PRESS firmly",
            hintIcon: "arrow.down.to.line"
        ),
        ZineFoldingStep(
            id: 4,
            title: "Unfold Completely",
            instruction: "Open the paper completely. You should see a grid of crease lines dividing the paper into 8 sections.",
            foldState: .unfoldedWithCreases,
            actionHint: nil,
            hintIcon: nil
        ),
        ZineFoldingStep(
            id: 5,
            title: "Fold in Half Horizontally",
            instruction: "Fold the paper in half horizontally (hamburger style), bringing the top edge down to meet the bottom edge.",
            foldState: .foldedHorizontalHalf,
            actionHint: "PRESS the fold",
            hintIcon: "arrow.down.to.line"
        ),
        ZineFoldingStep(
            id: 6,
            title: "Make the Cut",
            instruction: "Using scissors, cut along the center crease from the folded edge, stopping at the middle crease line. Only cut through 2 sections.",
            foldState: .cutCenter,
            actionHint: "✂️ Cut here",
            hintIcon: "scissors"
        ),
        ZineFoldingStep(
            id: 7,
            title: "Unfold the Paper",
            instruction: "Open the paper back up. You'll see the cut you made in the center of the page.",
            foldState: .unfoldedWithCut,
            actionHint: nil,
            hintIcon: nil
        ),
        ZineFoldingStep(
            id: 8,
            title: "Fold Long Ways",
            instruction: "Fold the paper in half the long way (hotdog style), with the cut opening up like a mouth.",
            foldState: .foldedLongWays,
            actionHint: nil,
            hintIcon: nil
        ),
        ZineFoldingStep(
            id: 9,
            title: "Push Inward",
            instruction: "Hold the ends and push them toward each other. The cut will open up and the paper will start to form a cross shape.",
            foldState: .pushedInward,
            actionHint: "Push gently",
            hintIcon: "arrow.left.arrow.right"
        ),
        ZineFoldingStep(
            id: 10,
            title: "Form the Pages",
            instruction: "Continue pushing and guide the pages into a book shape. The sections will naturally fold into place.",
            foldState: .formingPages,
            actionHint: nil,
            hintIcon: nil
        ),
        ZineFoldingStep(
            id: 11,
            title: "Complete!",
            instruction: "Flatten your zine and crease the spine. You now have an 8-page booklet ready to fill with your art and ideas!",
            foldState: .completedZine,
            actionHint: "YUM! 🎉",
            hintIcon: "sparkles"
        )
    ]
}
