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
    @State private var searchText = ""
    @State private var selectedInfoFile: InfoFile?
    @State private var hasAppeared = false
    @Namespace private var animation
    
    // MARK: - Info Files Data
    
    /// Array of information files
    private let infoFiles: [InfoFile] = [
        InfoFile(
            title: "iOS Keywords",
            markdownContent: iOSKeywordsMarkdown
        ),
        InfoFile(
            title: "iOS Poetry",
            markdownContent: iOSPoetryMarkdown
        )
    ]
    
    // MARK: - Demo Data
    
    /// Array of all available demos
    private let demos: [Demo] = [
        Demo(
            title: "Robotic",
            description: "Animated robot hand in immersive 3D space",
            destination: AnyView(RoboticDemoView()),
            date: "021026",
            indexTags: ["RealityKit"],
            quarter: "q1-w26"
        ),
        Demo(
            title: "Text Weight",
            description: "Calculate the hidden weight of English words",
            destination: AnyView(TextWeightDemoView()),
            date: "020926",
            indexTags: ["Canvas"],
            quarter: "q1-w26"
        ),
        Demo(
            title: "Collage",
            description: "Drag, rotate, and layer photos into a dynamic collage",
            destination: AnyView(CollageDemoView()),
            date: "020926",
            indexTags: ["PhotosUI"],
            quarter: "q1-w26"
        ),
        Demo(
            title: "8-Page Zine",
            description: "Interactive paper folding tutorial for mini booklets",
            destination: AnyView(ZineDemoView()),
            date: "020626",
            indexTags: ["Canvas"],
            quarter: "q1-w26"
        ),
        Demo(
            title: "Ultra-Rare Card",
            description: "Collectible card with an adventurous feel",
            destination: AnyView(RareCardDemoView()),
            date: "020626",
            indexTags: ["QuartzCore", "Canvas"],
            quarter: "q1-w26"
        ),
        Demo(
            title: "Ramen Machine",
            description: "3D vending machine",
            destination: AnyView(RamenMachineView()),
            date: "020426",
            indexTags: ["SceneKit"],
            quarter: "q1-w26"
        ),
        Demo(
            title: "Thermal Interaction",
            description: "Touch-responsive thermal visualization with heat",
            destination: AnyView(ThermalDemoView()),
            date: "020426",
            indexTags: ["MetalKit", "QuartzCore"],
            quarter: "q1-w26"
        ),
        Demo(
            title: "Piano",
            description: "Play Old MacDonald with interactive piano keys",
            destination: AnyView(PianoDemoView()),
            date: "020426",
            indexTags: ["AVFoundation"],
            quarter: "q1-w26"
        ),
        Demo(
            title: "Bubble Wrap",
            description: "Tap-to-pop bubble wrap with PBR materials",
            destination: AnyView(BubbleWrapDemoView()),
            date: "020426",
            indexTags: ["MetalKit"],
            quarter: "q1-w26"
        )
    ]
    
    /// Filtered demos based on search text
    private var filteredDemos: [Demo] {
        if searchText.isEmpty {
            return demos
        } else {
            return demos.filter { demo in
                demo.title.localizedCaseInsensitiveContains(searchText) ||
                demo.description.localizedCaseInsensitiveContains(searchText) ||
                demo.indexTags.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Search bar
                    SearchBarView(searchText: $searchText)
                        .padding(.horizontal, 24)
                        .padding(.top, 12)
                        .padding(.bottom, 8)
                        .opacity(hasAppeared ? 1 : 0)
                        .offset(y: hasAppeared ? 0 : -20)
                    
                    // Info Section
                    infoSection
                        .opacity(hasAppeared ? 1 : 0)
                        .offset(y: hasAppeared ? 0 : -15)
                    
                    // Info Files Row
                    if !infoFiles.isEmpty {
                        InfoFilesRow(files: infoFiles, selectedFile: $selectedInfoFile)
                            .padding(.top, 12)
                            .opacity(hasAppeared ? 1 : 0)
                            .offset(y: hasAppeared ? 0 : -10)
                    }
                    
                    // Demo List
                    demoListContent
                }
            }
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showAttributes) {
                AttributesView()
            }
            .sheet(item: $selectedInfoFile) { file in
                InfoFileDetailView(file: file)
            }
            .onAppear {
                withAnimation(.smooth(duration: 0.8, extraBounce: 0.0)) {
                    hasAppeared = true
                }
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
                            Text("SceneKit")
                                .font(.system(size: 10, weight: .light, design: .monospaced))
                                .foregroundStyle(.secondary)
                            Text("•")
                                .font(.system(size: 10, weight: .light))
                                .foregroundStyle(.secondary.opacity(0.5))
                            Text("MetalKit")
                                .font(.system(size: 10, weight: .light, design: .monospaced))
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack(spacing: 8) {
                            Text("AVFoundation")
                                .font(.system(size: 10, weight: .light, design: .monospaced))
                                .foregroundStyle(.secondary)
                            Text("•")
                                .font(.system(size: 10, weight: .light))
                                .foregroundStyle(.secondary.opacity(0.5))
                            Text("QuartzCore")
                                .font(.system(size: 10, weight: .light, design: .monospaced))
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack(spacing: 8) {
                            Text("Canvas")
                                .font(.system(size: 10, weight: .light, design: .monospaced))
                                .foregroundStyle(.secondary)
                            Text("•")
                                .font(.system(size: 10, weight: .light))
                                .foregroundStyle(.secondary.opacity(0.5))
                            Text("RealityKit")
                                .font(.system(size: 10, weight: .light, design: .monospaced))
                                .foregroundStyle(.secondary)
                        }
                        
                        HStack(spacing: 8) {
                            Text("PhotosUI")
                                .font(.system(size: 10, weight: .light, design: .monospaced))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .padding(.trailing, 24)
        }
        .padding(.top, 4)
    }
    
    // MARK: - Demo List Content
    
    private var demoListContent: some View {
        VStack(spacing: 0) {
            ForEach(Array(filteredDemos.enumerated()), id: \.element.id) { index, demo in
                NavigationLink(destination: demo.destination) {
                    DemoRow(demo: demo)
                }
                .buttonStyle(.plain)
                .opacity(hasAppeared ? 1 : 0)
                .offset(y: hasAppeared ? 0 : 10)
                .animation(
                    .smooth(duration: 0.5, extraBounce: 0.0)
                    .delay(Double(index) * 0.05),
                    value: hasAppeared
                )
            }
            
            // Show message when no results
            if filteredDemos.isEmpty {
                VStack(spacing: 8) {
                    Text("No demos found")
                        .font(.system(size: 14, weight: .light, design: .default))
                        .foregroundStyle(.secondary)
                    Text("Try a different search term")
                        .font(.system(size: 12, weight: .light, design: .default))
                        .foregroundStyle(.secondary.opacity(0.7))
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 40)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 24)
    }
}
