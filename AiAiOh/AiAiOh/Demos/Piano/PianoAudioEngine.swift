//
//  PianoAudioEngine.swift
//  AiAiOh
//  2/4/26
//  Audio synthesis engine for piano tones
//

import Foundation
import AVFoundation

// MARK: - Piano Audio Engine

/// Handles audio synthesis for piano tones using AVAudioEngine
@Observable
class PianoAudioEngine {
    
    // MARK: - Properties
    
    private var audioEngine: AVAudioEngine?
    private var isSetup = false
    
    // MARK: - Setup
    
    /// Configures the audio session and engine
    func setup() {
        guard !isSetup else { return }
        
        // Configure audio session
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default)
            try session.setActive(true)
        } catch {
            print("Failed to setup audio session: \(error)")
        }
        
        audioEngine = AVAudioEngine()
        isSetup = true
    }
    
    // MARK: - Play Note
    
    /// Plays a piano note at the given frequency
    /// - Parameters:
    ///   - frequency: The frequency in Hz
    ///   - duration: The duration in seconds
    func playNote(frequency: Double, duration: Double = 0.5) {
        guard isSetup, let engine = audioEngine else {
            setup()
            playNote(frequency: frequency, duration: duration)
            return
        }
        
        let sampleRate: Double = 44100.0
        let numSamples = Int(sampleRate * duration)
        
        // Create audio format
        guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1) else { return }
        
        // Create buffer
        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: AVAudioFrameCount(numSamples)) else { return }
        buffer.frameLength = AVAudioFrameCount(numSamples)
        
        // Generate piano-like waveform with harmonics and envelope
        guard let floatData = buffer.floatChannelData?[0] else { return }
        
        for i in 0..<numSamples {
            let time = Double(i) / sampleRate
            
            // ADSR envelope for piano-like sound
            let envelope = calculateEnvelope(time: time, duration: duration)
            
            // Add harmonics for richer piano sound
            let sample = generatePianoSample(frequency: frequency, time: time, envelope: envelope)
            floatData[i] = Float(sample)
        }
        
        // Create and configure player node
        let playerNode = AVAudioPlayerNode()
        engine.attach(playerNode)
        engine.connect(playerNode, to: engine.mainMixerNode, format: format)
        
        // Start engine if needed
        if !engine.isRunning {
            do {
                try engine.start()
            } catch {
                print("Failed to start audio engine: \(error)")
                return
            }
        }
        
        // Schedule and play
        playerNode.scheduleBuffer(buffer, completionHandler: { [weak self, weak playerNode] in
            DispatchQueue.main.async {
                if let node = playerNode, let engine = self?.audioEngine {
                    engine.detach(node)
                }
            }
        })
        playerNode.play()
    }
    
    // MARK: - Cleanup
    
    /// Stops and cleans up the audio engine
    func stop() {
        audioEngine?.stop()
        audioEngine = nil
        isSetup = false
    }
    
    // MARK: - Private Helpers
    
    /// Calculates ADSR envelope value for a given time
    private func calculateEnvelope(time: Double, duration: Double) -> Double {
        let attackTime = 0.01
        let decayTime = 0.1
        let sustainLevel = 0.6
        let releaseStart = duration - 0.1
        
        if time < attackTime {
            return time / attackTime
        } else if time < attackTime + decayTime {
            let decayProgress = (time - attackTime) / decayTime
            return 1.0 - (1.0 - sustainLevel) * decayProgress
        } else if time < releaseStart {
            return sustainLevel
        } else {
            let releaseProgress = (time - releaseStart) / 0.1
            return sustainLevel * (1.0 - releaseProgress)
        }
    }
    
    /// Generates a piano-like sample with harmonics
    private func generatePianoSample(frequency: Double, time: Double, envelope: Double) -> Double {
        let fundamental = sin(2.0 * .pi * frequency * time)
        let harmonic2 = sin(2.0 * .pi * frequency * 2.0 * time) * 0.5
        let harmonic3 = sin(2.0 * .pi * frequency * 3.0 * time) * 0.25
        let harmonic4 = sin(2.0 * .pi * frequency * 4.0 * time) * 0.125
        
        return (fundamental + harmonic2 + harmonic3 + harmonic4) * envelope * 0.3
    }
}
