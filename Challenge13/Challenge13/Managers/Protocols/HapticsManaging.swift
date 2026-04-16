//
//  HapticsManaging.swift
//  Challenge13
//
//  Created by Raquel Souza on 16/04/26.
//

import UIKit

//qualquer um que assinar esse protocolo, precisa implementar essas funções 
protocol HapticsManaging {
    func trigger()
    func setEnabled(_ enabled: Bool)
}
