//
//  SoundManaging.swift
//  Challenge13
//
//  Created by Raquel Souza on 17/04/26.
//

import AVFoundation

// MARK: - Protocol para SoundManager
protocol SoundManaging {
    var player: AVAudioPlayer? { get }
    
    func playSound(isEnabled: Bool) -> Void
    func reset() -> Void
}
