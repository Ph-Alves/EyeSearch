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
    /// Singleton
    static var shared: HapticsManaging { get }
    /// Dispara uma vibração tátil se estiver habilitado.
    func trigger()
    /// Define o estado de habilitação dos haptics.
    /// - Parameter enabled: `true` para habilitar, `false` para desabilitar.
    func setEnabled(_ enabled: Bool)
    /// Restaura os haptics para o estado padrão (habilitado).
    func reset()
}
