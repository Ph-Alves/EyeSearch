//
//  SoundManager.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 14/04/26.
//

import Foundation
import AVFoundation

// MARK: - Manager
/// # Manager - SoundManager
/// Gerencia a reprodução de sons de feedback utilizando `AVAudioPlayer`.
/// Toca o som de detecção quando um objeto adesivado é encontrado.
/// ## Usado em:
/// - ``SettingsViewModel``
final class SoundManager: SoundManaging {
    // MARK: - Variables
    /// Instância do player de áudio.
    private(set)var player: AVAudioPlayer?
    
    // MARK: - Init
    init() {}
    
    // MARK: - Functions
    /// Reproduz o som de feedback "item-found" se o som estiver habilitado pelo usuário.
    /// - Parameter isEnabled: Indica se o som está habilitado nas configurações.
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
    
    /// Restaura o manager para o estado padrão, liberando o player de áudio.
    func reset() {
        player = nil
    }
}
