//
//  AudioManager.swift
//  BallsTest
//
//  Created by muser on 08.12.2024.
//

import Foundation
import AVFoundation

class AudioManager: ObservableObject {
    @Published var isMusicEnabled: Bool = true
    private var audioPlayer: AVAudioPlayer?
    @Published var volume: Float = 0.1 {
        didSet {
            audioPlayer?.volume = volume
        }
    }
    
    init() {
        setupAudioPlayer()
    }
    
    private func setupAudioPlayer() {
        guard let url = Bundle.main.url(forResource: "background", withExtension: "mp3") else {
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1
            audioPlayer?.volume = volume
            audioPlayer?.prepareToPlay()
        } catch {
            print("error: \(error.localizedDescription)")
        }
    }
    
    func play() {
        audioPlayer?.play()
    }
    
    func stop() {
        audioPlayer?.stop()
    }
}
