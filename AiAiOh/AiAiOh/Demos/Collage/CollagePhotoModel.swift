//
//  CollagePhotoModel.swift
//  AiAiOh
//  2/9/26
//

import SwiftUI 

// MARK: - Collage Photo Model

struct CollagePhoto: Identifiable {
    let id = UUID()
    let image: UIImage
    var position: CGSize
    var rotation: Angle
    var zIndex: Double
}
