//
//  SoundManager.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 14/04/26.
//

import Foundation
import AVFoundation

// É um singleton, ou seja, só permite uma instância dele no projeto
class SoundManager {
    
    // Essa é a instância, é static pois permite o uso sem precisar instanciar a classe antes, até por que ela também é uma instância.
    static let manager = SoundManager()
    private var muted: Bool = false
    var player: AVAudioPlayer?
    
    // Init privado para proibir instanciação manual
    private init() {}
    
    // Função de tocar som a partir de um url (.mp3 do audio)
    func playSound() {
        if muted { return } else {
            guard let url = Bundle.main.url(forResource: "item-found", withExtension: "mp3") else { return }
            
            do {
                // instância do objeto audioPlayer
                player = try AVAudioPlayer(contentsOf: url)
                player?.setVolume(10, fadeDuration: 3)
                player?.play()
            } catch {
                print("Error iniciating AVAudioPlayer: \(error.localizedDescription)")
            }
        }
    }
    
    // Altera o som entre on/off
    func toggleSound() {
        self.muted.toggle()
    }
    
    // Reseta o manager para as configurações padrão
    func reset() {
        self.muted = false
        self.player = nil
    }
}
