//
//  PianoModels.swift
//  AiAiOh
//  2/4/26
//  Data models for the Piano demo
//

import Foundation

// MARK: - Song Note Model

/// Represents a single note in the song
struct SongNote: Identifiable {
    let id = UUID()
    let note: String      // Note name (C, D, E, etc.)
    let octave: Int       // Octave number
    let lyric: String     // Corresponding lyric syllable
    let duration: Double  // Beat duration (1.0 = quarter note)
}

// MARK: - Piano Key Model

/// Represents a piano key
struct PianoKey: Identifiable {
    let id = UUID()
    let note: String
    let octave: Int
    let isBlack: Bool
    let frequency: Double
    
    /// Display label for the key
    var label: String {
        note
    }
}

// MARK: - Song Data

/// Contains the melody data for Old MacDonald
enum OldMacDonaldSong {
    
    /// Old MacDonald melody notes
    static let notes: [SongNote] = [
        // "Old MacDonald had a farm"
        SongNote(note: "G", octave: 4, lyric: "Old", duration: 1),
        SongNote(note: "G", octave: 4, lyric: "Mac", duration: 1),
        SongNote(note: "G", octave: 4, lyric: "Don", duration: 1),
        SongNote(note: "D", octave: 4, lyric: "ald", duration: 1),
        SongNote(note: "E", octave: 4, lyric: "had", duration: 1),
        SongNote(note: "E", octave: 4, lyric: "a", duration: 1),
        SongNote(note: "D", octave: 4, lyric: "farm", duration: 2),
        
        // "E-I-E-I-O"
        SongNote(note: "B", octave: 4, lyric: "E", duration: 1),
        SongNote(note: "B", octave: 4, lyric: "I", duration: 1),
        SongNote(note: "A", octave: 4, lyric: "A", duration: 1),
        SongNote(note: "A", octave: 4, lyric: "I", duration: 1),
        SongNote(note: "G", octave: 4, lyric: "O", duration: 2),
    ]
}

// MARK: - Piano Keys Data

/// Contains the piano keyboard configuration
enum PianoKeyboard {
    
    /// Available piano keys (one octave plus high C)
    static let keys: [PianoKey] = [
        PianoKey(note: "C", octave: 4, isBlack: false, frequency: 261.63),
        PianoKey(note: "C#", octave: 4, isBlack: true, frequency: 277.18),
        PianoKey(note: "D", octave: 4, isBlack: false, frequency: 293.66),
        PianoKey(note: "D#", octave: 4, isBlack: true, frequency: 311.13),
        PianoKey(note: "E", octave: 4, isBlack: false, frequency: 329.63),
        PianoKey(note: "F", octave: 4, isBlack: false, frequency: 349.23),
        PianoKey(note: "F#", octave: 4, isBlack: true, frequency: 369.99),
        PianoKey(note: "G", octave: 4, isBlack: false, frequency: 392.00),
        PianoKey(note: "G#", octave: 4, isBlack: true, frequency: 415.30),
        PianoKey(note: "A", octave: 4, isBlack: false, frequency: 440.00),
        PianoKey(note: "A#", octave: 4, isBlack: true, frequency: 466.16),
        PianoKey(note: "B", octave: 4, isBlack: false, frequency: 493.88),
        PianoKey(note: "C", octave: 5, isBlack: false, frequency: 523.25)
    ]
    
    /// White keys only
    static var whiteKeys: [PianoKey] {
        keys.filter { !$0.isBlack }
    }
    
    /// Black keys only
    static var blackKeys: [PianoKey] {
        keys.filter { $0.isBlack }
    }
    
    /// Returns the black key that should appear after a white note, if any
    static func blackKeyAfter(whiteNote: String, octave: Int) -> PianoKey? {
        // Black keys appear after C, D, F, G, A (not after E or B)
        let blackNoteMap: [String: String] = [
            "C": "C#",
            "D": "D#",
            "F": "F#",
            "G": "G#",
            "A": "A#"
        ]
        
        guard let blackNote = blackNoteMap[whiteNote] else { return nil }
        return keys.first { $0.note == blackNote && $0.octave == octave }
    }
}
