//
//  AttributesView.swift
//  AiAiOh
//
//  2/4/26
//

import SwiftUI

// MARK: - Attribution Model

struct Attribution: Identifiable {
    let id = UUID()
    let title: String
    let creator: String
    let url: String
    let license: String
    let licenseURL: String?
}

// MARK: - Attributes View

struct AttributesView: View {
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Attribution Data
    
    private let attributions: [Attribution] = [
        Attribution(
            title: "Ramen Vending Machine",
            creator: "JustFaith",
            url: "https://skfb.ly/otUrG",
            license: "CC BY 4.0",
            licenseURL: "http://creativecommons.org/licenses/by/4.0/"
        ),
        Attribution(
            title: "Orca Swimming Gracefully Underwater in Ocean Depths",
            creator: "Nico Marín",
            url: "https://www.pexels.com/photo/orca-swimming-gracefully-underwater-in-ocean-depths-35015132/",
            license: "CC BY 4.0",
            licenseURL: "http://creativecommons.org/licenses/by/4.0/"
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
                    
                    // Bottom 60% - Attribution List
                    attributionListSection
                        .frame(height: geometry.size.height * 0.60)
                }
            }
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 15, weight: .light, design: .default))
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
    }
    
    // MARK: - Info Section
    
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("The following assets were used in this project:")
                .font(.system(size: 13, weight: .light, design: .default))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
        .padding(.top, 30)
    }
    
    // MARK: - Attribution List Section
    
    private var attributionListSection: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ForEach(attributions) { attribution in
                    AttributionRow(attribution: attribution)
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - Attribution Row

struct AttributionRow: View {
    let attribution: Attribution
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                // Title
                Text(attribution.title)
                    .font(.system(size: 16, weight: .light, design: .default))
                    .foregroundStyle(.primary)
                
                // Creator
                Text("by \(attribution.creator)")
                    .font(.system(size: 11, weight: .light, design: .default))
                    .foregroundStyle(.secondary)
                
                // Asset URL
                Link(destination: URL(string: attribution.url)!) {
                    Text(attribution.url)
                        .font(.system(size: 11, weight: .light, design: .monospaced))
                        .foregroundStyle(.blue)
                        .underline()
                }
                
                // License
                HStack(spacing: 4) {
                    Text("License:")
                        .font(.system(size: 11, weight: .light, design: .default))
                        .foregroundStyle(.secondary)
                    
                    if let licenseURL = attribution.licenseURL {
                        Link(destination: URL(string: licenseURL)!) {
                            Text(attribution.license)
                                .font(.system(size: 11, weight: .light, design: .default))
                                .foregroundStyle(.blue)
                                .underline()
                        }
                    } else {
                        Text(attribution.license)
                            .font(.system(size: 11, weight: .light, design: .default))
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 20)
            
            // Minimal separator
            Rectangle()
                .fill(Color(.separator))
                .frame(height: 0.5)
        }
    }
}
