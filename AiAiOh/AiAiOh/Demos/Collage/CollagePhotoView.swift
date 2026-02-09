//
//  CollagePhotoView.swift
//  AiAiOh
//  2/9/26
//

import SwiftUI

// MARK: - Collage Photo View

struct CollagePhotoView: View {
    
    let photo: CollagePhoto
    let onBringToFront: () -> Void
    let onPositionChange: (CGSize) -> Void
    let onRotationChange: (Angle) -> Void
    
    @State private var currentPosition: CGSize
    @State private var currentRotation: Angle
    @State private var isDragging = false
    @State private var scale: CGFloat = 0.1
    
    init(photo: CollagePhoto, onBringToFront: @escaping () -> Void, onPositionChange: @escaping (CGSize) -> Void, onRotationChange: @escaping (Angle) -> Void) {
        self.photo = photo
        self.onBringToFront = onBringToFront
        self.onPositionChange = onPositionChange
        self.onRotationChange = onRotationChange
        _currentPosition = State(initialValue: photo.position)
        _currentRotation = State(initialValue: photo.rotation)
    }
    
    var body: some View {
        Image(uiImage: photo.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 220)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(isDragging ? 0.3 : 0.15), radius: isDragging ? 20 : 10, y: isDragging ? 8 : 4)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(.white, lineWidth: 4)
            )
            .scaleEffect(isDragging ? 1.05 : 1.0)
            .scaleEffect(scale)
            .rotationEffect(currentRotation)
            .offset(x: currentPosition.width, y: currentPosition.height)
            .zIndex(photo.zIndex)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if !isDragging {
                            isDragging = true
                            onBringToFront()
                        }
                        currentPosition = CGSize(
                            width: photo.position.width + value.translation.width,
                            height: photo.position.height + value.translation.height
                        )
                    }
                    .onEnded { value in
                        isDragging = false
                        onPositionChange(currentPosition)
                    }
            )
            .simultaneousGesture(
                RotationGesture()
                    .onChanged { angle in
                        currentRotation = photo.rotation + angle
                    }
                    .onEnded { angle in
                        onRotationChange(currentRotation)
                    }
            )
            .onAppear {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                    scale = 1.0
                }
            }
    }
}
