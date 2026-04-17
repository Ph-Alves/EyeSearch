//
//  SettingsViewModel.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 14/04/26.
//

import Foundation
import Combine

@Observable
class SettingsViewModel {
    
    //Dependências
    private let haptics: HapticsManaging
    private var soundManager: SoundManager
    private let settingsManager: SettingsManager
    
    
    var settings: UserSettings
    
    //init recebendo o manager de fora
    init(haptics: HapticsManaging, settingsManager: SettingsManager = SettingsManager()) {
            self.haptics = haptics
            self.settingsManager = settingsManager
            self.soundManager = SoundManager.manager
            
            //carrega o UserDefaults
            self.settings = settingsManager.load()
        }
    
    
    //MARK: Haptics
    func toggleHaptics() {
        settings.isHapticsEnabled.toggle()
        settingsManager.save(settings)
    }
    
    func triggerHaptic() {
        haptics.trigger(isEnabled: settings.isHapticsEnabled)
    }
    
    
    //MARK: Sound
    
    func toggleSound() {
        soundManager.toggleSound()
    }
    
    func resetConfiguration() {
        soundManager.reset()
        haptics.reset()
    }
}
