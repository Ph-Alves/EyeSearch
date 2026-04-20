//
//  SoundManaging.swift
//  Challenge13
//
//  Created by Raquel Souza on 17/04/26.
//

import AVFoundation

protocol SoundManaging {
    var player: AVAudioPlayer? { get }
    func playSound(isEnabled: Bool) -> Void
    func reset() -> Void
}
