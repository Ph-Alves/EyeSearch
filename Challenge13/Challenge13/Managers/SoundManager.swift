//
//  SoundManager.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 14/04/26.
//

import Foundation
import AVFoundation

final class SoundManager: SoundManaging {
    // MARK: - Variables
    private(set) var player: AVAudioPlayer?
    
    // MARK: - Init
    init() {}
    
    // MARK: - Functions
    // Função de tocar som a partir de um url (.mp3 do audio)
    func playSound(isEnabled: Bool) {
        guard isEnabled else { return }
        
        guard let url = Bundle.main.url(forResource: "item-found", withExtension: "mp3") else { return }
        
        do {
            // instância do objeto audioPlayer
            player = try AVAudioPlayer(contentsOf: url)
            player?.setVolume(10, fadeDuration: 3)
            player?.play()
        } catch {
            print("Error initiating AVAudioPlayer: \(error.localizedDescription)")
        }
    }
    
    // Reseta o manager para as configurações padrão
    func reset() {
            player = nil
    }
}
