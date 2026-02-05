//
//  AttributionModel.swift
//  AiAiOh
//  2/5/26
//  Model for attrubutions 
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
