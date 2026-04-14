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
    static let shared = SoundManager()
    var player: AVAudioPlayer?
    
    // Init privado para proibir instanciação manual
    private init() {}
    
    // Função de tocar som, pega um url e tenta dar play.
    func playSound() {
        guard let url = URL(string: "") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Error iniciating AVAudioPlayer: \(error.localizedDescription)")
        }
    }
}
