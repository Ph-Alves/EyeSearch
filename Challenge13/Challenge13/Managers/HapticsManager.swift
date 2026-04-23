//
//  HapticsManager.swift
//  Challenge13
//
//  Created by Raquel Souza on 15/04/26.
//

import UIKit

// MARK: - Manager
/// # Manager - HapticsManager
/// Gerencia o feedback tátil (haptics) do app utilizando `UIImpactFeedbackGenerator`.
/// Permite disparar vibrações, habilitar/desabilitar e restaurar configurações padrão.
/// ## Usado em:
/// - ``SettingsViewModel``
final class HapticsManager: HapticsManaging {
    // MARK: - Variables
    // Estado atual de habilitação dos haptics.
    private var isEnabled: Bool = true

    // MARK: - Init
    init() { }
    
    // MARK: - Functions
    /// Dispara uma vibração tátil com intensidade média.
    /// - Parameter isEnabled: Indica se o haptic está habilitado pelo usuário.
    func trigger(isEnabled: Bool) {
        guard isEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred(intensity: 1)
    }
    
    /// Define o estado de habilitação dos haptics.
    /// - Parameter enabled: `true` para habilitar, `false` para desabilitar.
    func setEnabled(_ enabled: Bool) {
        self.isEnabled = enabled
    }
    
    /// Restaura os haptics para o estado padrão (habilitado).
    func reset() {
        isEnabled = true
    }
}
