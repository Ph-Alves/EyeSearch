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

// MARK: - Manager
//criando a classe e assinando o protocolo
final class HapticsManager: HapticsManaging {
    // MARK: - Variables
    private var isEnabled: Bool = true

    // MARK: - Init
    init() { }
    
    // MARK: - Functions
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
