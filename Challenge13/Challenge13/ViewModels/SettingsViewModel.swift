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
    
    // MARK: - Variables
    //injetando a dependência - usando o protocolo, e não a classe
    private let haptics: HapticsManaging
    private var soundManager: SoundManager
    
    // MARK: - Init

    //init recebendo o manager de fora
    init(haptics:  HapticsManaging) {
        self.haptics = haptics
        self.soundManager = SoundManager.manager
    }
    
    // MARK: - Functions
    func toggleSound() {
        soundManager.toggleSound()
    }
    
    //Função chamada quando usuário muda o toggle
    func toogleHaptics() {
        //sincroniza o valor que está na UI com a lógica do manager
        haptics.setEnabled()
    }
    
    func resetConfiguration() {
        soundManager.reset()
        haptics.reset()
    }
}
