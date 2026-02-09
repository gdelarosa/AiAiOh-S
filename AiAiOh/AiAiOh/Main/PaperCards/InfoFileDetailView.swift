//
//  InfoFileDetailView.swift
//  AiAiOh
//  2/5/26
//  Detail view for displaying info file markdown content
//

import SwiftUI

// MARK: - Info File Detail View

/// Popup view displaying the markdown content of an info file
struct InfoFileDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    let file: InfoFile
    
    @State private var contentOpacity: Double = 0
    @State private var contentOffset: CGFloat = 20
    @State private var scrollOffset: CGFloat = 0
    @State private var toolbarBlur: Double = 0
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        // Split markdown into paragraphs for line-by-line animation
                        AnimatedMarkdownText(
                            content: file.markdownContent,
                            isVisible: contentOpacity > 0
                        )
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(24)
                    .background(
                        GeometryReader { scrollGeo in
                            Color.clear
                                .preference(
                                    key: ScrollOffsetPreferenceKey.self,
                                    value: scrollGeo.frame(in: .named("scroll")).minY
                                )
                        }
                    )
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    withAnimation(.smooth(duration: 0.2)) {
                        scrollOffset = value
                        toolbarBlur = min(max(-value / 50, 0), 1)
                    }
                }
            }
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(file.title)
                        .font(.system(size: 14, weight: .light, design: .default))
                        .kerning(1)
                        .opacity(toolbarBlur)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        withAnimation(.smooth(duration: 0.3)) {
                            contentOpacity = 0
                            contentOffset = 20
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            dismiss()
                        }
                    }
                    .font(.system(size: 15, weight: .light, design: .default))
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(
                Color(.systemBackground)
                    .opacity(0.7 + (toolbarBlur * 0.3)),
                for: .navigationBar
            )
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(24)
        .presentationBackground(.regularMaterial)
        .onAppear {
            withAnimation(.smooth(duration: 0.4, extraBounce: 0.0)) {
                contentOpacity = 1
                contentOffset = 0
            }
        }
    }
}

// MARK: - Animated Markdown Text

struct AnimatedMarkdownText: View {
    let content: String
    let isVisible: Bool
    
    @State private var visibleLines: Set<Int> = []
    
    private var lines: [String] {
        content.components(separatedBy: "\n")
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(lines.enumerated()), id: \.offset) { index, line in
                if !line.isEmpty {
                    Text(.init(line))
                        .font(.system(size: 15, weight: .light, design: .default))
                        .foregroundStyle(.primary)
                        .textSelection(.enabled)
                        .opacity(visibleLines.contains(index) ? 1 : 0)
                        .offset(y: visibleLines.contains(index) ? 0 : 10)
                        .blur(radius: visibleLines.contains(index) ? 0 : 3)
                        .animation(
                            .smooth(duration: 0.6, extraBounce: 0.0)
                                .delay(Double(index) * 0.015),
                            value: visibleLines.contains(index)
                        )
                } else {
                    Text(" ")
                        .font(.system(size: 15, weight: .light, design: .default))
                }
            }
        }
        .onAppear {
            // Trigger line-by-line reveal
            for index in 0..<lines.count {
                visibleLines.insert(index)
            }
        }
        .onChange(of: isVisible) { oldValue, newValue in
            if newValue {
                visibleLines.removeAll()
                for index in 0..<lines.count {
                    visibleLines.insert(index)
                }
            } else {
                visibleLines.removeAll()
            }
        }
    }
}

// MARK: - Scroll Offset Preference Key

private struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
