//
//  UserSettings.swift
//  Challenge13
//
//  Created by Raquel Souza on 16/04/26.
//

import Foundation

//MARK: - Models
struct UserSettings {
    var isHapticsEnabled: Bool
    var isSoundEnabled: Bool
}

//MARK: - Manager (Persistência com UserDefault)
class SettingsManager {
    
    private let userDefaults = UserDefaults.standard
    
    private enum Keys {
        static let haptics = "isHapticsEnabled"
        static let sound = "isSoundEnabled"
    }
    
    // MARK: - Load completo
    func load() -> UserSettings {
        return UserSettings(
            isHapticsEnabled: userDefaults.object(forKey: Keys.haptics) as? Bool ?? true,
            isSoundEnabled: userDefaults.object(forKey: Keys.sound) as? Bool ?? true,
        )
    }
    
    // MARK: - Save completo
    func save(_ settings: UserSettings) {
        userDefaults.set(settings.isHapticsEnabled, forKey: Keys.haptics)
        userDefaults.set(settings.isSoundEnabled, forKey: Keys.sound)
    }
}
