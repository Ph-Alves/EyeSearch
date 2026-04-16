//
//  SettingsViewModel.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 14/04/26.
//

import Foundation

@Observable
class SettingsViewModel {
    
    // MARK: - Variables
    private var hapticsManager: HapticsManager
    private var soundManager: SoundManager
    
    // MARK: - Init
    init() {
        self.hapticsManager = HapticsManager.manager
        self.soundManager = SoundManager.manager
    }
    
    // MARK: - Functions
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
