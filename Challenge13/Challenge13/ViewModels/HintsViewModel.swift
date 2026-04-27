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
        Hint(id: UUID(), title: String(localized: String.LocalizationValue(L10n.Hints.Card.HowToUse.title)),        description: String(localized: String.LocalizationValue(L10n.Hints.Card.HowToUse.description))),
        Hint(id: UUID(), title: String(localized: String.LocalizationValue(L10n.Hints.Card.ManageEmotions.title)),  description: String(localized: String.LocalizationValue(L10n.Hints.Card.ManageEmotions.description))),
        Hint(id: UUID(), title: String(localized: String.LocalizationValue(L10n.Hints.Card.FocusTips.title)),       description: String(localized: String.LocalizationValue(L10n.Hints.Card.FocusTips.description)))
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
