//
//  SettingsManager.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 17/04/26.
//

import Foundation

// MARK: - Manager (Persistência com UserDefault)
final class SettingsManager: SettingsManaging {
    // MARK: - Variables
    private let userDefaults = UserDefaults.standard
    private enum Keys {
        static let haptics = "isHapticsEnabled"
        static let sound = "isSoundEnabled"
    }
    
    // MARK: - Init
    init() { }
    
    // MARK: - Functions
    // Load
    func load() -> UserSettings {
        return UserSettings(
            isHapticsEnabled: userDefaults.object(forKey: Keys.haptics) as? Bool ?? true,
            isSoundEnabled: userDefaults.object(forKey: Keys.sound) as? Bool ?? true
        )
    }
    
    // Save
    func save(_ settings: UserSettings) -> Void {
        userDefaults.set(settings.isHapticsEnabled, forKey: Keys.haptics)
        userDefaults.set(settings.isSoundEnabled, forKey: Keys.sound)
    }
}
