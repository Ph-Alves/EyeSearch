//
//  SettingsViewModel.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 14/04/26.
//

import Foundation

@Observable
class SettingsViewModel {
    
    private var hapticsManager: HapticsManager
    private var soundManager: SoundManager
    
    init() {
        self.hapticsManager = HapticsManager.manager
        self.soundManager = SoundManager.manager
    }
    
    func toggleSound() {
        soundManager.toggleSound()
    }
    
    func changeHaptics() {
        hapticsManager.toggleHaptics()
    }
    
    func resetConfiguration() {
        soundManager.reset()
        hapticsManager.reset()
    }
}
