//
//  SettingsManaging.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 20/04/26.
//

import Foundation

// MARK: - Protocol
/// # Protocol - SettingsManaging
/// Interface para persistência das configurações do usuário via `UserDefaults`.
/// ## Implementado por:
/// - ``SettingsManager``
protocol SettingsManaging {
    /// Singleton
    static var shared: SettingsManaging { get }
    /// Carrega as configurações salvas do usuário.
    /// - Returns: Instância de ``UserSettings`` com os valores persistidos.
    func load() -> UserSettings
    /// Salva as configurações do usuário.
    /// - Parameter settings: Configurações a serem persistidas.
    func save(_ settings: UserSettings)
}
