//
//  DemoListView.swift
//  AiAiOh
//  2/4/26
//  Main navigation view listing all available demos
//

import SwiftUI

// MARK: - Demo List View

struct DemoListView: View {
    
    // MARK: - State
    
    @State private var showAttributes = false
    
    // MARK: - Demo Data
    
    /// Array of all available demos
    private let demos: [Demo] = [
        Demo(
            title: "Ramen Machine",
            description: "3D vending machine",
            destination: AnyView(RamenMachineView()),
            date: "020426"
        ),
        Demo(
            title: "Thermal Interaction",
            description: "Touch-responsive thermal visualization with heat effects",
            destination: AnyView(ThermalDemoView()),
            date: "020426"
        ),
        Demo(
            title: "Piano",
            description: "Play Old MacDonald with interactive piano keys",
            destination: AnyView(PianoDemoView()),
            date: "020426"
        ),
        Demo(
            title: "Bubble Wrap",
            description: "Tap-to-pop bubble wrap with PBR materials",
            destination: AnyView(BubbleWrapDemoView()),
            date: "020426"
        )
    ]
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {
                    // Top 40% - Info Section
                    infoSection
                        .frame(height: geometry.size.height * 0.40)
                    
                    // Bottom 60% - Demo List
                    demoListSection
                        .frame(height: geometry.size.height * 0.60)
                }
            }
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showAttributes) {
                AttributesView()
            }
        }
    }
    
    // MARK: - Info Section
    
    private var infoSection: some View {
        HStack(alignment: .top, spacing: 0) {
            // Left Column - Square layout label
            VStack(alignment: .leading, spacing: 2) {
                Text("swiftui")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(.primary)
                Text("iOS demos")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(.primary)
                Text("q1-w26")
                    .font(.system(size: 18, weight: .medium, design: .rounded))
                    .foregroundStyle(.primary)
            }
            .padding(.leading, 24)
            
            Spacer()
            
            // Right Column - Metadata
            VStack(alignment: .trailing, spacing: 20) {
                Text("created by gina dlr")
                    .font(.system(size: 13, weight: .light, design: .default))
                    .foregroundStyle(.secondary)
                
                Button(action: {
                    showAttributes = true
                }) {
                    Text("attributes")
                        .font(.system(size: 13, weight: .light, design: .default))
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                
                VStack(alignment: .trailing, spacing: 8) {
                    Text("index")
                        .font(.system(size: 13, weight: .light, design: .default))
                        .foregroundStyle(.secondary)
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        HStack(spacing: 8) {
                            Text("3D")
                                .font(.system(size: 10, weight: .light, design: .monospaced))
                                .foregroundStyle(.secondary)
                            Text("·")
                                .font(.system(size: 10, weight: .light))
                                .foregroundStyle(.secondary.opacity(0.5))
                            Text("Metal")
                                .font(.system(size: 10, weight: .light, design: .monospaced))
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack(spacing: 8) {
                            Text("tap")
                                .font(.system(size: 10, weight: .light, design: .monospaced))
                                .foregroundStyle(.secondary)
                            Text("·")
                                .font(.system(size: 10, weight: .light))
                                .foregroundStyle(.secondary.opacity(0.5))
                            Text("drag")
                                .font(.system(size: 10, weight: .light, design: .monospaced))
                                .foregroundStyle(.secondary)
                            Text("·")
                                .font(.system(size: 10, weight: .light))
                                .foregroundStyle(.secondary.opacity(0.5))
                            Text("gesture")
                                .font(.system(size: 10, weight: .light, design: .monospaced))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding(.trailing, 24)
        }
        .padding(.top, 40)
    }
    
    // MARK: - Demo List Section
    
    private var demoListSection: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(demos) { demo in
                    NavigationLink(destination: demo.destination) {
                        DemoRow(demo: demo)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 24)
        }
    }
}
