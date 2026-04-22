//
//  HintsViewModel.swift
//  Challenge13
//
//  Created by Raquel Souza on 17/04/26.
//

import Foundation

// MARK: - ViewModel
/// # ViewModel - HintsViewModel
/// ViewModel da tela de dicas de acessibilidade.
/// Gerencia a lista de dicas e controla qual dica está expandida na interface.
/// ## Usado em:
/// - ``HintsView``
@Observable
class HintsViewModel {
    // MARK: - Variables
    /// Lista de dicas exibidas na tela.
    var hints: [Hint] = [
        Hint(id: UUID(), title: "Como usar o app", description: "Explore os recursos e registre seus pensamentos diariamente."),
        Hint(id: UUID(), title: "Gerenciar emoções", description: "Escreva com frequência para identificar padrões emocionais."),
        Hint(id: UUID(), title: "Dicas de foco", description: "Reserve alguns minutos do dia para refletir e se organizar.")
    ]
    
    /// ID da dica atualmente expandida. `nil` se nenhuma estiver aberta.
    var selectedHintID: UUID?
    
    // MARK: - Functions
    /// Alterna o estado de expansão de uma dica. Se já estiver aberta, fecha. Se estiver fechada, abre.
    /// - Parameter hint: A dica que foi tocada pelo usuário.
    func toggleHint(_ hint: Hint) {
        if selectedHintID == hint.id {
            selectedHintID = nil
        } else {
            selectedHintID = hint.id
        }
    }
}
