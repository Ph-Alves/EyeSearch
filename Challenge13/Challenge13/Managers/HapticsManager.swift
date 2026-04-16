//
//  HapticsManager.swift
//  Challenge13
//
//  Created by Raquel Souza on 15/04/26.
//


import UIKit

class HapticsManager: HapticsManaging {
    
    private var isEnabled: Bool = true
    
    func trigger() {
        guard isEnabled else { return }
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    
    func setEnabled(_ enabled: Bool) {
        self.isEnabled = enabled
    }
}
