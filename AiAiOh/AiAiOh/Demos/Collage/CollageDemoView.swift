//
//  CollageDemoView.swift
//  AiAiOh
//  2/9/26
//  Interactive photo collage with drag and layer reordering
//

import SwiftUI
import PhotosUI

// MARK: - Collage Demo View

struct CollageDemoView: View {
    
    @State private var photos: [CollagePhoto] = []
    @State private var selectedItem: PhotosPickerItem?
    @State private var nextZIndex: Double = 0
    @State private var usedRotations: Set<Int> = []
    
    var body: some View {
        ZStack {
            // Background
            Color(.systemBackground)
                .ignoresSafeArea()
            
            // Collage canvas
            ZStack {
                ForEach(photos) { photo in
                    CollagePhotoView(
                        photo: photo,
                        onBringToFront: {
                            bringToFront(photo)
                        },
                        onPositionChange: { newPosition in
                            updatePosition(for: photo, to: newPosition)
                        },
                        onRotationChange: { newRotation in
                            updateRotation(for: photo, to: newRotation)
                        }
                    )
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // Add photo button
            VStack {
                Spacer()
                
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    HStack(spacing: 8) {
                        Image(systemName: "photo.badge.plus")
                            .font(.system(size: 16, weight: .medium))
                        Text("Add Photo")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                    }
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 14)
                    .background(
                        Capsule()
                            .fill(.black)
                            .shadow(color: .black.opacity(0.2), radius: 12, y: 4)
                    )
                }
                .buttonStyle(.plain)
                .padding(.bottom, 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Collage")
                    .font(.system(size: 17, weight: .medium, design: .rounded))
            }
        }
        .onChange(of: selectedItem) { oldValue, newValue in
            Task {
                if let data = try? await newValue?.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    addPhoto(uiImage)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func addPhoto(_ image: UIImage) {
        // Generate a unique rotation that hasn't been used yet
        var randomRotation: Double
        var rotationKey: Int
        
        repeat {
            randomRotation = Double.random(in: -25...25)
            rotationKey = Int(randomRotation.rounded())
        } while usedRotations.contains(rotationKey)
        
        usedRotations.insert(rotationKey)
        
        let newPhoto = CollagePhoto(
            image: image,
            position: .zero,
            rotation: Angle(degrees: randomRotation),
            zIndex: nextZIndex
        )
        
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            photos.append(newPhoto)
            nextZIndex += 1
        }
    }
    
    private func bringToFront(_ photo: CollagePhoto) {
        guard let index = photos.firstIndex(where: { $0.id == photo.id }) else { return }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            photos[index].zIndex = nextZIndex
            nextZIndex += 1
        }
    }
    
    private func updatePosition(for photo: CollagePhoto, to position: CGSize) {
        guard let index = photos.firstIndex(where: { $0.id == photo.id }) else { return }
        photos[index].position = position
    }
    
    private func updateRotation(for photo: CollagePhoto, to rotation: Angle) {
        guard let index = photos.firstIndex(where: { $0.id == photo.id }) else { return }
        photos[index].rotation = rotation
    }
}
