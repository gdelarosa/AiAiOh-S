//
//  DemoListView.swift
//  AiAiOh
//
//  Main navigation view listing all available demos
//

import SwiftUI

// MARK: - Demo Model

/// Represents a single demo in the app
struct Demo: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let destination: AnyView
}

// MARK: - Demo List View

struct DemoListView: View {
    
    // MARK: - Demo Data
    
    /// Array of all available demos
    private let demos: [Demo] = [
        Demo(
            title: "Thermal Interaction",
            description: "Touch-responsive thermal visualization with beautiful heat effects",
            destination: AnyView(ThermalDemoView())
        ),
        Demo(
            title: "Bubble Wrap",
            description: "Hyper-realistic tap-to-pop bubble wrap with PBR materials",
            destination: AnyView(BubbleWrapDemoView())
        )
        // Add more demos here as they're created
    ]
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            List(demos) { demo in
                NavigationLink(destination: demo.destination) {
                    DemoRow(demo: demo)
                }
            }
            .navigationTitle("AI-AI-Oh")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// MARK: - Demo Row

/// Individual row displaying demo information
struct DemoRow: View {
    let demo: Demo
    
    var body: some View {
        HStack(spacing: 16) {
            // Text content
            VStack(alignment: .leading, spacing: 4) {
                Text(demo.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(demo.description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 8)
    }
}
