//
//  OpenSearchObjectIntent.swift
//  EyeSearchWidgets
//
//  Created by Paulo Henrique Costa Alves on 24/04/26.
//

import AppIntents
import Foundation

/// Intent usado pelos widgets para abrir o app na tela de busca de objetos.
/// Ao ser executado, o sistema abre o app (via `openAppWhenRun`)
/// e o `onOpenURL` no `Challenge13App` cuida da navegação.
struct OpenSearchObjectWidgetIntent: AppIntent {
    /// Titulo intent
    static var title: LocalizedStringResource = "Buscar objeto"
    /// Descrição
    static var description = IntentDescription("Abre a tela de busca de objetos com a câmera.")
    /// Variável do protocolo que abre o app antes de executar o perform
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult & OpensIntent {
        .result(opensIntent: OpenURLIntent(URL(string: "eyesearch://searchObject")!))
    }
}
