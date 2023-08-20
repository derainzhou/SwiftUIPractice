//
//  AudioPlayer.swift
//  CS193p
//
//  Created by DerainZhou on 2023/8/20.
//

import Foundation
import AVFAudio

class AudioPlayer {
    static let shared = AudioPlayer()
    
    private lazy var player: AVAudioPlayer? = {
        guard let fileURL = Bundle.main.url(forResource: "SomethingJustLikeThis", withExtension: "mp3") else {
            return nil
        }
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer.numberOfLoops = .max
            // audioPlayer.volume = 0.0
            return audioPlayer
        } catch  {
            print("AudioPlayer: create player failed, error: \(error)")
            return nil
        }
    }()
    
    init() {
        player?.prepareToPlay()
    }
}

// MARK: - Public Method
extension AudioPlayer {
    public func play() {
        player?.play()
    }
    
    public func pause() {
        player?.pause()
    }
}
