//
//  SoundManaging.swift
//  Challenge13
//
//  Created by Raquel Souza on 17/04/26.
//

import AVFoundation

// MARK: - Protocol
/// # Protocol - SoundManaging
/// Interface para reprodução de sons de feedback no app.
/// ## Implementado por:
/// - ``SoundManager``
protocol SoundManaging {
    /// Reproduz o som de feedback quando um objeto é detectado.
    /// - Parameter isEnabled: Indica se o som está habilitado pelo usuário.
    func playSound(isEnabled: Bool)
    /// Fala o label do objeto detectado no idioma do dispositivo.
    /// - Parameters:
    ///   - isEnabled: Indica se o som está habilitado pelo usuário.
    ///   - label: Raw value do label YOLO (ex: `"person"`, `"chair"`).
    func speakLabel(isEnabled: Bool, label: String)
    /// Restaura o manager para o estado padrão, liberando o player.
    func reset()
}
