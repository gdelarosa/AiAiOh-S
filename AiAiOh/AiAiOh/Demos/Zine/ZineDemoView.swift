//
//  ZineDemoView.swift
//  AiAiOh
//  2/6/26
//  Interactive 8-page zine folding tutorial with animated paper transformations
//

import SwiftUI

// MARK: - Zine Demo View

/// Main coordinator view for the 8-page zine folding tutorial
/// Demonstrates SwiftUI animations, gestures, and Canvas rendering
struct ZineDemoView: View {
    
    // MARK: - State
    
    @State private var currentStep: Int = 0
    @State private var isAnimating: Bool = false
    @State private var showCompletion: Bool = false
    @State private var dragOffset: CGFloat = 0
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Constants
    
    private let steps = ZineFoldingStep.allSteps
    private let swipeThreshold: CGFloat = 50
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                backgroundGradient
                
                VStack(spacing: 0) {
                    // Header
                    headerSection
                    
                    // Main content area
                    ZStack {
                        // Paper visualization
                        ZinePaperView(
                            step: steps[currentStep],
                            isAnimating: $isAnimating
                        )
                        .padding(.horizontal, 32)
                        .offset(x: dragOffset)
                    }
                    .frame(maxHeight: .infinity)
                    
                    // Instruction panel
                    instructionPanel
                    
                    // Navigation controls
                    navigationControls
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.secondary)
                }
            }
        }
        .gesture(swipeGesture)
        .sheet(isPresented: $showCompletion) {
            ZineCompletionView()
        }
    }
    
    // MARK: - Background
    
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(.systemBackground),
                Color(.systemGray6).opacity(0.5)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    // MARK: - Header Section
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("8-PAGE ZINE")
                .font(.system(size: 11, weight: .semibold, design: .monospaced))
                .tracking(3)
                .foregroundStyle(.secondary)
            
            Text("Paper Folding Guide")
                .font(.system(size: 24, weight: .light, design: .serif))
                .foregroundStyle(.primary)
        }
        .padding(.top, 16)
        .padding(.bottom, 24)
    }
    
    // MARK: - Instruction Panel
    
    private var instructionPanel: some View {
        VStack(spacing: 16) {
            // Step indicator dots
            HStack(spacing: 8) {
                ForEach(0..<steps.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentStep ? Color.primary : Color.secondary.opacity(0.3))
                        .frame(width: index == currentStep ? 8 : 6, height: index == currentStep ? 8 : 6)
                        .animation(.easeInOut(duration: 0.2), value: currentStep)
                }
            }
            .padding(.top, 20)
            
            // Step number
            Text("Step \(currentStep + 1) of \(steps.count)")
                .font(.system(size: 12, weight: .medium, design: .monospaced))
                .foregroundStyle(.secondary)
            
            // Instruction title
            Text(steps[currentStep].title)
                .font(.system(size: 20, weight: .medium, design: .default))
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
            
            // Instruction description
            Text(steps[currentStep].instruction)
                .font(.system(size: 14, weight: .regular, design: .default))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
                .padding(.horizontal, 32)
            
            // Action hint
            if let hint = steps[currentStep].actionHint {
                HStack(spacing: 6) {
                    Image(systemName: steps[currentStep].hintIcon ?? "hand.tap")
                        .font(.system(size: 12))
                    Text(hint)
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                }
                .foregroundStyle(.blue.opacity(0.8))
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(
                    Capsule()
                        .fill(Color.blue.opacity(0.1))
                )
            }
        }
        .padding(.bottom, 16)
    }
    
    // MARK: - Navigation Controls
    
    private var navigationControls: some View {
        HStack(spacing: 40) {
            // Previous button
            Button(action: previousStep) {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .medium))
                    Text("Back")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(currentStep > 0 ? Color.primary : Color.secondary.opacity(0.3))
            }
            .disabled(currentStep == 0 || isAnimating)
            
            // Step counter
            Text("\(currentStep + 1)/\(steps.count)")
                .font(.system(size: 16, weight: .light, design: .monospaced))
                .foregroundStyle(.secondary)
                .frame(width: 50)
            
            // Next button
            Button(action: nextStep) {
                HStack(spacing: 8) {
                    Text(currentStep == steps.count - 1 ? "Done" : "Next")
                        .font(.system(size: 14, weight: .medium))
                    Image(systemName: currentStep == steps.count - 1 ? "checkmark" : "chevron.right")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundStyle(.primary)
            }
            .disabled(isAnimating)
        }
        .padding(.vertical, 24)
        .padding(.bottom, 16)
    }
    
    // MARK: - Gestures
    
    private var swipeGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                guard !isAnimating else { return }
                dragOffset = value.translation.width * 0.3
            }
            .onEnded { value in
                guard !isAnimating else { return }
                
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    dragOffset = 0
                }
                
                if value.translation.width < -swipeThreshold && currentStep < steps.count - 1 {
                    nextStep()
                } else if value.translation.width > swipeThreshold && currentStep > 0 {
                    previousStep()
                }
            }
    }
    
    // MARK: - Navigation Actions
    
    private func nextStep() {
        guard !isAnimating else { return }
        
        if currentStep == steps.count - 1 {
            showCompletion = true
            return
        }
        
        isAnimating = true
        withAnimation(.easeInOut(duration: 0.4)) {
            currentStep += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isAnimating = false
        }
    }
    
    private func previousStep() {
        guard !isAnimating, currentStep > 0 else { return }
        
        isAnimating = true
        withAnimation(.easeInOut(duration: 0.4)) {
            currentStep -= 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isAnimating = false
        }
    }
}

