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
    
    // MARK: - Info Files Data
    
    /// Array of information files
    private let infoFiles: [InfoFile] = [
        InfoFile(
            title: "iOS Keywords",
            markdownContent: iOSKeywordsMarkdown
        )
        // Add more files here
    ]
    
    // MARK: - Demo Data
    
    /// Array of all available demos
    private let demos: [Demo] = [
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
                    
                    // Info Section
                    infoSection
                    
                    // Info Files Row
                    if !infoFiles.isEmpty {
                        InfoFilesRow(files: infoFiles, selectedFile: $selectedInfoFile)
                            .padding(.top, 12)
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
            ForEach(filteredDemos) { demo in
                NavigationLink(destination: demo.destination) {
                    DemoRow(demo: demo)
                }
                .buttonStyle(.plain)
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
            }
        }
        .padding(.horizontal, 24)
    }
}
