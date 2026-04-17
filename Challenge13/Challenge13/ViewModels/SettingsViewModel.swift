//
//  SettingsViewModel.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 14/04/26.
//
/*
 exemplo para usar a função toggleHapctics na sua view:
    
 Toggle("Haptics", isOn: $viewModel.settings.isHapticsEnabled)
     .onChange(of: viewModel.settings.isHapticsEnabled) { newValue in
         viewModel.updateHaptics(newValue)
     }
 
 */

import Foundation

@Observable
class SettingsViewModel {
    
    //Dependências
    // MARK: - Variables
    //injetando a dependência - usando o protocolo, e não a classe
    private let haptics: HapticsManaging
    private let soundManager: SoundManaging
    private let settingsManager: SettingsManager
    
    
    var settings: UserSettings
    
    // MARK: - Init
    
    //init recebendo o manager de fora
    init(haptics: HapticsManaging, soundManager: SoundManaging = SoundManager.manager, settingsManager: SettingsManager = SettingsManager()) {
        self.haptics = haptics
        self.settingsManager = settingsManager
        self.soundManager = soundManager
        
        //carrega o UserDefaults
        self.settings = settingsManager.load()
    }
    
    
    //MARK: Haptics
    func toggleHaptics(_ enabled: Bool) {
        settings.isHapticsEnabled = enabled
        settingsManager.save(settings)
    }
    
    func triggerHaptic() {
        haptics.trigger(isEnabled: settings.isHapticsEnabled)
    }
    
    
    //MARK: Sound
    
    func toggleSound(_ enabled: Bool) {
        settings.isSoundEnabled = enabled
        settingsManager.save(settings)
    }
    
    func playSound() {
        soundManager.playSound(isEnabled: settings.isSoundEnabled)
    }
        
        
    func resetConfiguration() {
        settings = UserSettings(
            isHapticsEnabled: true,
            isSoundEnabled: true
        )
        
        settingsManager.save(settings)
        
        soundManager.reset()
        haptics.reset()
    }
}
