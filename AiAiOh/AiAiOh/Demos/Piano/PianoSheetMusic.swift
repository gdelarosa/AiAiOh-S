//
//  PianoSheetMusicView.swift
//  AiAiOh
//  2/4/26
//  Sheet music display component for Piano demo
//

import SwiftUI

// MARK: - Sheet Music View

/// Displays the song notation and current progress
struct PianoSheetMusicView: View {
    
    // MARK: - Properties
    
    let songNotes: [SongNote]
    let currentNoteIndex: Int
    let showLyrics: Bool
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 16) {
            // Title
            titleSection
            
            // Progress indicator
            progressIndicator
            
            // Note display
            noteScrollView
            
            // Instructions
            Text("Play the highlighted note on the piano below")
                .font(.system(size: 11, weight: .light, design: .default))
                .foregroundStyle(.secondary)
                .padding(.bottom, 16)
        }
    }
    
    // MARK: - Title Section
    
    private var titleSection: some View {
        VStack(spacing: 4) {
            Text("Old MacDonald Had a Farm")
                .font(.system(size: 18, weight: .medium, design: .serif))
                .foregroundStyle(.primary)
            
            Text("Traditional")
                .font(.system(size: 11, weight: .light, design: .default))
                .foregroundStyle(.secondary)
        }
        .padding(.top, 20)
    }
    
    // MARK: - Progress Indicator
    
    private var progressIndicator: some View {
        HStack(spacing: 4) {
            ForEach(0..<songNotes.count, id: \.self) { index in
                Circle()
                    .fill(index < currentNoteIndex ? Color.green : Color.secondary.opacity(0.3))
                    .frame(width: 6, height: 6)
            }
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Note Scroll View
    
    private var noteScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(songNotes.enumerated()), id: \.offset) { index, note in
                        NoteCardView(
                            note: note,
                            isCurrent: index == currentNoteIndex,
                            isPlayed: index < currentNoteIndex,
                            showLyrics: showLyrics
                        )
                        .id(index)
                    }
                }
                .padding(.horizontal, 24)
            }
            .onChange(of: currentNoteIndex) { _, newIndex in
                withAnimation(.easeInOut(duration: 0.3)) {
                    proxy.scrollTo(max(0, newIndex - 1), anchor: .leading)
                }
            }
        }
    }
}

// MARK: - Note Card View

/// A single note card in the sheet music display
struct NoteCardView: View {
    
    // MARK: - Properties
    
    let note: SongNote
    let isCurrent: Bool
    let isPlayed: Bool
    let showLyrics: Bool
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 8) {
            // Note name
            Text(note.note)
                .font(.system(size: 20, weight: isCurrent ? .semibold : .light, design: .monospaced))
                .foregroundStyle(isCurrent ? .white : (isPlayed ? .green : .primary))
            
            // Lyric
            if showLyrics {
                Text(note.lyric)
                    .font(.system(size: 10, weight: .light, design: .default))
                    .foregroundStyle(isCurrent ? .white.opacity(0.8) : .secondary)
            }
        }
        .frame(width: 44, height: 60)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isCurrent ? Color.blue : Color.secondary.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isPlayed ? Color.green : Color.clear, lineWidth: 1.5)
        )
    }
}
