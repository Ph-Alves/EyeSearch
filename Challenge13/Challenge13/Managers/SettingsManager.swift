//
//  SettingsManager.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 17/04/26.
//

import Foundation

// MARK: - Manager
/// # Manager - SettingsManager
/// Gerencia a persistência das configurações do usuário utilizando `UserDefaults`.
/// Salva e carrega preferências de haptics e som.
/// ## Usado em:
/// - ``SettingsViewModel``
final class SettingsManager: SettingsManaging {
    // MARK: - Variables
    /// Singleton
    static let shared: SettingsManaging = SettingsManager()
    /// Instância de UserDefaults para persistência.
    private let userDefaults = UserDefaults.standard
    /// Chaves utilizadas no UserDefaults.
    private enum Keys {
        static let haptics = "isHapticsEnabled"
        static let sound = "isSoundEnabled"
    }
    
    // MARK: - Init
    private init() {
        
    }
    
    // MARK: - Functions
    /// Carrega as configurações salvas do usuário. Retorna valores padrão (`true`) se não houver dados salvos.
    /// - Returns: Instância de `UserSettings` com os valores persistidos.
    func load() -> UserSettings {
        return UserSettings(
            isHapticsEnabled: userDefaults.object(forKey: Keys.haptics) as? Bool ?? true,
            isSoundEnabled: userDefaults.object(forKey: Keys.sound) as? Bool ?? true
        )
    }
    
    /// Salva as configurações do usuário no UserDefaults.
    /// - Parameter settings: Configurações a serem persistidas.
    func save(_ settings: UserSettings) {
        userDefaults.set(settings.isHapticsEnabled, forKey: Keys.haptics)
        userDefaults.set(settings.isSoundEnabled, forKey: Keys.sound)
    }
}
