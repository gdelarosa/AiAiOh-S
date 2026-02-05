//
//  PianoKeyboardView.swift
//  AiAiOh
//  2/4/26
//  Piano keyboard UI component
//

import SwiftUI

// MARK: - Piano Keyboard View

/// Displays an interactive piano keyboard
struct PianoKeyboardView: View {
    
    // MARK: - Properties
    
    let nextNote: SongNote?
    let onKeyPressed: (PianoKey) -> Void
    
    @State private var pressedKeys: Set<String> = []
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            let whiteKeys = PianoKeyboard.whiteKeys
            let whiteKeyWidth = max(1, geometry.size.width / CGFloat(whiteKeys.count))
            let blackKeyWidth = whiteKeyWidth * 0.6
            let whiteKeyHeight = max(1, geometry.size.height - 20)
            let blackKeyHeight = max(1, whiteKeyHeight * 0.6)
            
            ZStack(alignment: .top) {
                // White keys
                HStack(spacing: 0) {
                    ForEach(whiteKeys) { key in
                        WhiteKeyView(
                            key: key,
                            isPressed: pressedKeys.contains(keyIdentifier(key)),
                            isNextNote: isNextNoteToPlay(key),
                            width: whiteKeyWidth,
                            height: whiteKeyHeight,
                            onTap: { handleKeyPress(key) }
                        )
                    }
                }
                
                // Black keys overlay
                HStack(spacing: 0) {
                    ForEach(Array(whiteKeys.enumerated()), id: \.offset) { index, whiteKey in
                        ZStack {
                            if let blackKey = PianoKeyboard.blackKeyAfter(whiteNote: whiteKey.note, octave: whiteKey.octave) {
                                BlackKeyView(
                                    key: blackKey,
                                    isPressed: pressedKeys.contains(keyIdentifier(blackKey)),
                                    isNextNote: isNextNoteToPlay(blackKey),
                                    width: blackKeyWidth,
                                    height: blackKeyHeight,
                                    onTap: { handleKeyPress(blackKey) }
                                )
                                .offset(x: whiteKeyWidth * 0.5)
                            }
                        }
                        .frame(width: whiteKeyWidth)
                    }
                }
            }
            .padding(.top, 20)
        }
    }
    
    // MARK: - Helper Methods
    
    /// Creates a unique identifier for a key
    private func keyIdentifier(_ key: PianoKey) -> String {
        "\(key.note)\(key.octave)"
    }
    
    /// Checks if this key is the next note to play
    private func isNextNoteToPlay(_ key: PianoKey) -> Bool {
        guard let nextNote = nextNote else { return false }
        return key.note == nextNote.note && key.octave == nextNote.octave
    }
    
    /// Handles a key press with visual feedback
    private func handleKeyPress(_ key: PianoKey) {
        let id = keyIdentifier(key)
        
        // Visual feedback
        pressedKeys.insert(id)
        
        // Notify parent
        onKeyPressed(key)
        
        // Remove visual feedback after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            pressedKeys.remove(id)
        }
    }
}

// MARK: - White Key View

/// A single white piano key
struct WhiteKeyView: View {
    
    let key: PianoKey
    let isPressed: Bool
    let isNextNote: Bool
    let width: CGFloat
    let height: CGFloat
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                // Key background
                RoundedRectangle(cornerRadius: 4)
                    .fill(isPressed ? Color.gray.opacity(0.3) : Color.white)
                    .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
                
                // Highlight for next note
                if isNextNote {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.blue, lineWidth: 3)
                }
                
                // Key label
                VStack {
                    Spacer()
                    Text(key.label)
                        .font(.system(size: 14, weight: .light, design: .default))
                        .foregroundStyle(isNextNote ? .blue : .secondary)
                        .padding(.bottom, 12)
                }
            }
        }
        .buttonStyle(.plain)
        .frame(width: max(1, width - 2), height: max(1, height))
        .overlay(
            Rectangle()
                .fill(Color.black.opacity(0.1))
                .frame(width: 1),
            alignment: .leading
        )
    }
}

// MARK: - Black Key View

/// A single black piano key
struct BlackKeyView: View {
    
    let key: PianoKey
    let isPressed: Bool
    let isNextNote: Bool
    let width: CGFloat
    let height: CGFloat
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack {
                RoundedRectangle(cornerRadius: 3)
                    .fill(isPressed ? Color.gray : Color.black)
                    .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 2)
                
                // Highlight for next note
                if isNextNote {
                    RoundedRectangle(cornerRadius: 3)
                        .stroke(Color.blue, lineWidth: 3)
                }
                
                // Key label
                VStack {
                    Spacer()
                    Text(key.label)
                        .font(.system(size: 10, weight: .light, design: .default))
                        .foregroundStyle(isNextNote ? .blue : .white.opacity(0.6))
                        .padding(.bottom, 8)
                }
            }
        }
        .buttonStyle(.plain)
        .frame(width: max(1, width), height: max(1, height))
    }
}
