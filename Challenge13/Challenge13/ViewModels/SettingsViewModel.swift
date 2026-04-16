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
    
    //injetando a dependência - usando o protocolo, e não a classe
    private let haptics: HapticsManaging
    private var soundManager: SoundManager
    
    //Estado da UI
    @Published var isHapticsOn: Bool = true
    
    //init recebendo o manager de fora
    init(haptics:  HapticsManaging) {
        self.haptics = haptics
        self.soundManager = SoundManager.manager
    }
    
    func toggleSound() {
        soundManager.toggleSound()
    }
    
    //Função chamada quando usuário muda o toggle
    func toogleHaptics() {
        //sincroniza o valor que está na UI com a lógica do manager
        haptics.setEnabled(isHapticsOn)
    }
    
    func resetConfiguration() {
        soundManager.reset()
//        hapticsManager.reset()
    }
}
