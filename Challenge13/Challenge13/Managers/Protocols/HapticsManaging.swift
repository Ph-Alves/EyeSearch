//
//  HapticsManaging.swift
//  Challenge13
//
//  Created by Raquel Souza on 16/04/26.
//

import UIKit

// MARK: - Protocol
/// # Protocol - HapticsManaging
/// Interface para gerenciamento de feedback tátil (haptics) no app.
/// ## Implementado por:
/// - ``HapticsManager``
protocol HapticsManaging {
    /// Dispara uma vibração tátil se estiver habilitado.
    /// - Parameter isEnabled: Indica se o haptic está habilitado pelo usuário.
    func trigger(isEnabled: Bool)
    /// Define o estado de habilitação dos haptics.
    /// - Parameter enabled: `true` para habilitar, `false` para desabilitar.
    func setEnabled(_ enabled: Bool)
    /// Restaura os haptics para o estado padrão (habilitado).
    func reset()
}
