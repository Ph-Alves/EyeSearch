//
//  HapticsManager.swift
//  Challenge13
//
//  Created by Raquel Souza on 15/04/26.
//

//Para ser usado na sua ViewModel, você precisa injetar HapticsManaging na ViewModel via init e utilize trigger() para executar o haptic.
//Exemplo:
/*
 private let haptics: HapticsManaging
 
 init(haptics:  HapticsManaging) {
     self.haptics = haptics
 }
 
 */

import UIKit

//criando a classe e assinando o protocolo
class HapticsManager: HapticsManaging {
    
    private var isEnabled: Bool = true
    
    //var interna que controla o estado de ON/OFF
//    private var isHapticsEnabled: Bool = true
    
    //função que executa o haptic
    func trigger(isEnabled: Bool) {
        
        //Se estiver desativado, saia da função
        guard isEnabled else { return }
        
        //Cria o gerador de haptic com o estilo no medium
        let generator = UIImpactFeedbackGenerator(style: .medium)
        //Dispara a vibração
        generator.impactOccurred()
    }
    
    func setEnabled(_ enabled: Bool) {
        self.isEnabled = enabled
    }
    
    // Função de reset para as configs normais
    func reset() {
        isEnabled = true
    }
}
