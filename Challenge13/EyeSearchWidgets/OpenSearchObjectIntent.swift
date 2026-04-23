//
//  OpenSearchObjectIntent.swift
//  EyeSearch
//
//  Created by Paulo Henrique Costa Alves on 23/04/26.
//

import Foundation
import AppIntents

// MARK: - App Intent
/// # Manager - App Intent
/// Intent exposta à Siri e ao app Atalhos para abrir a tela de busca de objetos.
struct OpenSearchObjectIntent: AppIntent {
    static var title: LocalizedStringResource = "Buscar objeto"
    static var description = IntentDescription("Abre a tela de busca de objetos com a câmera.")

    /// Garante que o app seja trazido para o primeiro plano ao executar a intent.
    static var openAppWhenRun: Bool = true

    /// Define a ação do intents definido
    /// - Returns: um `IntentResult` que é o resultado de uma ação performada
    @MainActor
    func perform() async -> some IntentResult {
        #if !WIDGET_EXTENSION
        IntentsManager.shared.openSearchObject()
        #endif
        return .result()
    }
}
