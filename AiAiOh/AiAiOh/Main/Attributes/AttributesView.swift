//
//  AttributesView.swift
//  AiAiOh
//  2/4/26
//  A list of thanks for free resources used for these demos
//

import SwiftUI

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
        ),
        Attribution(
            title: "Crumpled paper texture",
            creator: "Vasilisa Designer",
            url: "https://www.figma.com/community/file/1151038862076532940/crumpled-paper-texture",
            license: "CC BY 4.0",
            licenseURL: "http://creativecommons.org/licenses/by/4.0/"
        ),
        Attribution(
            title: "Robot Hand Dying",
            creator: "Rukh3D",
            url: "https://sketchfab.com/3d-models/robot-hand-dying-581f6ed4fd1245f2b4b3e6fd69e6190c",
            license: "CC BY 4.0",
            licenseURL: "http://creativecommons.org/licenses/by/4.0/"
        ),
        Attribution(
            title: "Brewing Coffee with Siphon Method",
            creator: "Mario Spencer",
            url: "https://www.pexels.com/video/brewing-coffee-with-siphon-method-33701530/",
            license: "CC BY 4.0",
            licenseURL: "http://creativecommons.org/licenses/by/4.0/"
        ),
    ]
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Info Section
                infoSection
                    .padding(.top, 20)
                    .padding(.bottom, 16)
                
                // Attribution List
                attributionListSection
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
        Text("The following assets were used in this project:")
            .font(.system(size: 16, weight: .light, design: .default))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
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
