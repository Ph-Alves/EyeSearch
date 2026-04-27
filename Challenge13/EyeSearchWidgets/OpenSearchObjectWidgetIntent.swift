//
//  OpenSearchObjectIntent.swift
//  EyeSearchWidgets
//
//  Created by Paulo Henrique Costa Alves on 24/04/26.
//

import AppIntents
import Foundation

struct OpenSearchObjectWidgetIntent: AppIntent {
    static var title: LocalizedStringResource = "Buscar objeto"
    static var description = IntentDescription("Abre a tela de busca de objetos com a câmera.")
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult & OpensIntent {
        .result(opensIntent: OpenURLIntent(URL(string: "eyesearch://searchObject")!))
    }
}
