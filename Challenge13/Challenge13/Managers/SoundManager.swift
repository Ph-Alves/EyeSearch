//
//  SoundManager.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 14/04/26.
//

import Foundation
import AVFoundation


final class SoundManager: SoundManaging {
    
    // Essa é a instância, é static pois permite o uso sem precisar instanciar a classe antes, até por que ela também é uma instância.
    static let manager = SoundManager()
    var player: AVAudioPlayer?
    
    // Init privado para proibir instanciação manual
    private init() {}
    
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
    
    func reset() {
            player = nil
    }
}
