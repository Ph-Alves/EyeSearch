//
//  UserSettings.swift
//  Challenge13
//
//  Created by Raquel Souza on 16/04/26.
//

import Foundation

// MARK: - Model
/// # Model - UserSettings
/// Modelo de dados para usar de base nas configurações do usuários
/// ## Usado em:
/// - ``SettingsManager``
/// - ``SettingsViewModel``
struct UserSettings {
    /// Define se os haptics estão habilitados
    var isHapticsEnabled: Bool
    /// Define se o som está habilitado
    var isSoundEnabled: Bool
}
