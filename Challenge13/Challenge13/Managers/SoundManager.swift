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
/// - ``SearchObjectViewModel``
/// - ``SettingsViewModel``
final class SoundManager: SoundManaging {
    // MARK: - Variables
    /// Singleton
    static let shared: SoundManaging = SoundManager()
    /// Instância do player de áudio.
    private(set) var player: AVAudioPlayer?
    /// Sintetizador para falar o que receber de label
    private let synthesizer = AVSpeechSynthesizer()
    
    // MARK: - Init
    private init() {
        setupAudio()
    }
    
    // MARK: - Functions
    /// Reproduz o som de feedback "item-found" se o som estiver habilitado pelo usuário.
    /// - Parameter isEnabled: Indica se o som está habilitado nas configurações.
    func playSound(isEnabled: Bool) {
        guard isEnabled else { return }
        player?.play()
    }
    
    /// Executa uma fala a partir do label recebido
    /// - Parameter label: Um valor de string recebido do Yolo para ser falado
    func speakLabel(isEnabled: Bool, label: String) {
        guard isEnabled else { return }
        let cleanLabel = label.trimmingCharacters(in: .whitespaces)
        
        let textToSpeak = String.localized("yolo.label.\(cleanLabel)", table: L10n.YOLO.Label.table)
        guard !textToSpeak.hasPrefix("yolo.label.") else { return }

        let utterance = AVSpeechUtterance(string: textToSpeak)
        utterance.voice = AVSpeechSynthesisVoice(language: Locale.preferredLanguages.first ?? "en")
        utterance.rate = 0.53
        
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        synthesizer.speak(utterance)
    }
    
    /// Restaura o manager para o estado padrão, liberando o player de áudio.
    func reset() {
        player = nil
    }
    
    // MARK: - Private Functions
    
    /// Inicializa a sessão e prepara o audio
    private func setupAudio() {
        do {
            guard let url = Bundle.main.url(forResource: "ObjectFound", withExtension: "mp3") else { return }
            player = try AVAudioPlayer(contentsOf: url)
            player?.setVolume(0.2, fadeDuration: 0)
            try AVAudioSession.sharedInstance().setCategory(
                .playback,
                mode: .voicePrompt,
                options: [.mixWithOthers, .duckOthers]
            )
            try AVAudioSession.sharedInstance().setActive(true)
            
        } catch {
            print("Falha ao configurar Audio Session: \(error)")
        }
    }
}
