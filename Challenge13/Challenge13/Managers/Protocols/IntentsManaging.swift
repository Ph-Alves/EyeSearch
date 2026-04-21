//
//  IntentsManaging.swift
//  Challenge13
//
//  Created by Manoel Pedro Prado Sa Teles on 20/04/26.
//

import Foundation
import SwiftUI

// MARK: - Protocol
/// # Protocol - IntentsManaging
/// Interface para gerenciamento do intents do projeto
/// ## Implementado por:
/// - ``IntentsManager``
protocol IntentsManaging: AnyObject {
    /// Recebe um coordinator responsável por permitir o intents abrir o app em uma view específica
    var coordinator: Coordinator? { get set }
    /// Função de abrir a tela de procurar objeto, utilizando-se do ``Coordinator``
    @MainActor
    func openSearchObject()
}
