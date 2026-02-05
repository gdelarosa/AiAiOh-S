//
//  PianoDemoView.swift
//  AiAiOh
//  2/4/26
//  Interactive piano demo with Old MacDonald sheet music
//

import SwiftUI

// MARK: - Piano Demo View

struct PianoDemoView: View {
    
    // MARK: - State
    
    @State private var audioEngine = PianoAudioEngine()
    @State private var currentNoteIndex: Int = 0
    @State private var showLyrics: Bool = true
    
    // MARK: - Computed Properties
    
    /// The current note the user should play
    private var currentNote: SongNote? {
        guard currentNoteIndex < OldMacDonaldSong.notes.count else { return nil }
        return OldMacDonaldSong.notes[currentNoteIndex]
    }
    
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Sheet music section (top 45%)
                PianoSheetMusicView(
                    songNotes: OldMacDonaldSong.notes,
                    currentNoteIndex: currentNoteIndex,
                    showLyrics: showLyrics
                )
                .frame(height: geometry.size.height * 0.45)
                
                // Piano keys section (bottom 55%)
                PianoKeyboardView(
                    nextNote: currentNote,
                    onKeyPressed: handleKeyPressed
                )
                .frame(height: geometry.size.height * 0.55)
            }
        }
        .background(Color(.systemBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Piano")
                    .font(.system(size: 14, weight: .light, design: .default))
                    .kerning(2)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: resetProgress) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 14, weight: .light))
                        .foregroundStyle(.primary.opacity(0.7))
                }
            }
        }
        .onAppear {
            audioEngine.setup()
        }
        .onDisappear {
            audioEngine.stop()
        }
    }
    
    // MARK: - Actions
    
    /// Handles when a piano key is pressed
    private func handleKeyPressed(_ key: PianoKey) {
        // Play sound
        audioEngine.playNote(frequency: key.frequency, duration: 0.4)
        
        // Check if correct note
        if let expectedNote = currentNote,
           key.note == expectedNote.note && key.octave == expectedNote.octave {
            // Correct note - advance
            withAnimation(.easeInOut(duration: 0.2)) {
                currentNoteIndex += 1
            }
        }
    }
    
    /// Resets the song progress
    private func resetProgress() {
        currentNoteIndex = 0
    }
}
