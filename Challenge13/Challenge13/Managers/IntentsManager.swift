//
//  IntentsManager.swift
//  Challenge13
//
//  Created by Manoel Pedro Prado Sa Teles on 20/04/26.
//

import Foundation
import AppIntents
import SwiftUI

// Responsável por expor o Coordinator ao sistema de App Intents (Siri/Atalhos),
// mantendo a responsabilidade única de navegação no Coordinator.
final class IntentsManager: IntentsManaging {
    
    // Instância compartilhada para ser acessada dentro de AppIntents,
    // já que AppIntents são instanciados pelo sistema e não têm acesso ao Environment.
    static let shared = IntentsManager()

    // Referência fraca ao Coordinator para evitar ciclo de retenção.
    weak var coordinator: Coordinator?

    
    private init() { }

    // Navega até a SearchObjectView respeitando o padrão do Coordinator.
    @MainActor
    func openSearchObject() {
        guard let coordinator else { return }

        if !coordinator.path.isEmpty {
            coordinator.popToRoot()
        }

        coordinator.navigate(to: .searchObject)
    }
}

// MARK: - App Intent
// Intent exposta à Siri e ao app Atalhos para abrir a tela de busca de objetos.
struct OpenSearchObjectIntent: AppIntent {
    static var title: LocalizedStringResource = "Buscar objeto"
    static var description = IntentDescription("Abre a tela de busca de objetos pela câmera.")

    // Garante que o app seja trazido para o primeiro plano ao executar a intent.
    static var openAppWhenRun: Bool = true

    @MainActor
    func perform() async throws -> some IntentResult {
        IntentsManager.shared.openSearchObject()
        return .result()
    }
}

// MARK: - App Shortcuts Provider
// Expõe as frases que a Siri reconhece para ativar a intent sem configuração do usuário.
struct Challenge13Shortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: OpenSearchObjectIntent(),
            phrases: [
                "Buscar objeto com \(.applicationName)",
                "Abrir busca no \(.applicationName)",
                "Procurar objeto no \(.applicationName)"
            ],
            shortTitle: "Buscar objeto",
            systemImageName: "magnifyingglass"
        )
    }
}
