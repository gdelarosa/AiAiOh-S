//
//  TextWeightDemoView.swift
//  AiAiOh
//  2/9/26
//  Interactive demo for calculating and visualizing English word weights
//

import SwiftUI

// MARK: - Text Weight Demo View

struct TextWeightDemoView: View {
    
    // MARK: - State
    
    @State private var inputText = ""
    @State private var result: WordWeightResult?
    @State private var showResult = false
    @State private var isCalculating = false
    @FocusState private var isInputFocused: Bool
    
    // MARK: - Body
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                inputSection
                    .padding(.top, 32)
                
                if let result = result {
                    resultSection(result)
                        .transition(.opacity.combined(with: .offset(y: 12)))
                }
                
                Spacer(minLength: 80)
            }
            .padding(.horizontal, 28)
        }
        .scrollDismissesKeyboard(.interactively)
        .background(Color(.systemBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Text Weight")
                    .font(.system(size: 16, weight: .light, design: .default))
            }
        }
        .onTapGesture {
            isInputFocused = false
        }
    }
    
    // MARK: - Input Section
    
    private var inputSection: some View {
        VStack(spacing: 24) {
            // Prompt
            Text("enter a word")
                .font(.system(size: 12, weight: .light))
                .tracking(1.5)
                .foregroundStyle(.secondary.opacity(0.5))
                .textCase(.uppercase)
            
            // Text field
            TextField("", text: $inputText, prompt: Text("word")
                .font(.system(size: 32, weight: .ultraLight, design: .serif))
                .foregroundColor(.secondary.opacity(0.18))
            )
            .font(.system(size: 32, weight: .ultraLight, design: .serif))
            .foregroundStyle(.primary)
            .multilineTextAlignment(.center)
            .textInputAutocapitalization(.characters)
            .autocorrectionDisabled()
            .focused($isInputFocused)
            .submitLabel(.done)
            .onSubmit { calculateWeight() }
            .padding(.vertical, 4)
            
            // Subtle underline
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(.separator).opacity(0),
                            Color(.separator).opacity(0.3),
                            Color(.separator).opacity(0)
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 0.5)
                .padding(.horizontal, 40)
            
            // Calculate button
            Button(action: calculateWeight) {
                HStack(spacing: 6) {
                    if isCalculating {
                        ProgressView()
                            .tint(.white)
                            .scaleEffect(0.7)
                    } else {
                        Image(systemName: "scalemass")
                            .font(.system(size: 12, weight: .medium))
                    }
                    
                    Text("Weigh")
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                }
                .foregroundColor(inputText.isEmpty ? Color.secondary : .white)
                .padding(.horizontal, 24)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(inputText.isEmpty ? Color(.systemFill) : .primary)
                )
            }
            .buttonStyle(.plain)
            .disabled(inputText.isEmpty || isCalculating)
            .animation(.smooth(duration: 0.25), value: inputText.isEmpty)
        }
    }
    
    // MARK: - Result Section
    
    private func resultSection(_ result: WordWeightResult) -> some View {
        VStack(spacing: 0) {
            
            // Gauge
            TextWeightGauge(
                totalWeight: result.totalWeight,
                label: result.label,
                isVisible: showResult
            )
            .padding(.top, 40)
            
            // Arithmetic breakdown: base + bonus = total
            arithmeticRow(result)
                .padding(.top, 20)
                .opacity(showResult ? 1 : 0)
                .animation(.easeOut(duration: 0.35).delay(0.3), value: showResult)
            
            // Modifier badges
            TextWeightModifierBadges(
                modifiers: result.modifiers,
                isVisible: showResult
            )
            .padding(.top, 14)
            
            // Divider
            sectionDivider
                .padding(.top, 24)
            
            // Letter breakdown header
            HStack {
                Text("breakdown")
                    .font(.system(size: 10, weight: .medium))
                    .tracking(1.5)
                    .foregroundStyle(.secondary.opacity(0.4))
                    .textCase(.uppercase)
                
                Spacer()
            }
            .padding(.top, 16)
            .padding(.bottom, 12)
            .opacity(showResult ? 1 : 0)
            .animation(.easeOut(duration: 0.3).delay(0.15), value: showResult)
            
            // Letter bars
            VStack(spacing: 2) {
                ForEach(Array(result.breakdown.enumerated()), id: \.element.id) { index, letterWeight in
                    TextWeightLetterBar(
                        letterWeight: letterWeight,
                        index: index,
                        isVisible: showResult
                    )
                }
            }
        }
    }
    
    // MARK: - Arithmetic Row
    
    private func arithmeticRow(_ result: WordWeightResult) -> some View {
        HStack(spacing: 0) {
            if result.modifiers.total > 0 {
                arithmeticUnit(value: "\(result.baseWeight)", label: "base")
                
                arithmeticOperator("+")
                    .padding(.horizontal, 12)
                
                arithmeticUnit(value: "\(result.modifiers.total)", label: "bonus")
                
                arithmeticOperator("=")
                    .padding(.horizontal, 12)
                
                arithmeticUnit(value: "\(result.totalWeight)", label: "total", bold: true)
            } else {
                arithmeticUnit(value: "\(result.totalWeight)", label: "total")
            }
        }
    }
    
    private func arithmeticUnit(value: String, label: String, bold: Bool = false) -> some View {
        VStack(spacing: 2) {
            Text(value)
                .font(.system(size: 16, weight: bold ? .regular : .light, design: .monospaced))
                .foregroundStyle(.primary)
            Text(label)
                .font(.system(size: 9, weight: .light))
                .foregroundStyle(.secondary.opacity(0.5))
        }
    }
    
    private func arithmeticOperator(_ op: String) -> some View {
        Text(op)
            .font(.system(size: 13, weight: .ultraLight))
            .foregroundStyle(.secondary.opacity(0.35))
    }
    
    // MARK: - Section Divider
    
    private var sectionDivider: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        Color(.separator).opacity(0),
                        Color(.separator).opacity(0.2),
                        Color(.separator).opacity(0)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: 0.5)
    }
    
    // MARK: - Actions
    
    private func calculateWeight() {
        guard !inputText.isEmpty else { return }
        isInputFocused = false
        
        withAnimation(.smooth(duration: 0.2)) {
            isCalculating = true
            showResult = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let calculated = TextWeightCalculator.calculate(inputText)
            
            withAnimation(.smooth(duration: 0.35)) {
                result = calculated
                isCalculating = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                withAnimation(.smooth(duration: 0.3)) {
                    showResult = true
                }
            }
        }
    }
}
