//
//  IntentsManager.swift
//  Challenge13
//
//  Created by Manoel Pedro Prado Sa Teles on 20/04/26.
//

import Foundation
import AppIntents
import SwiftUI

// MARK: - Manager
/// # Manager - IntentsManager
/// Responsável por expor o Coordinator ao sistema de App Intents (Siri/Atalhos),
/// mantendo a responsabilidade única de navegação no Coordinator.
/// ## Usado em:
/// - ``Challenge13App``
final class IntentsManager: IntentsManaging {
    // MARK: - Variables
    /// Instância compartilhada para ser acessada dentro de AppIntents,
    /// já que AppIntents são instanciados pelo sistema e não têm acesso ao Environment.
    static let shared: IntentsManaging = IntentsManager()

    /// Referência fraca ao Coordinator para evitar ciclo de retenção.
    weak var coordinator: Coordinator? {
        didSet {
            if coordinator != nil, hasPendingDeepLink {
                hasPendingDeepLink = false
                Task { @MainActor in
                    openSearchObject()
                }
            }
        }
    }
    
    private var hasPendingDeepLink = false

    // MARK: - Init
    private init() {
        
    }

    /// Navega até a SearchObjectView respeitando o padrão do ``Coordinator``.
    @MainActor
    func openSearchObject() {
        guard let coordinator else {
            hasPendingDeepLink = true
            return
        }

        if !coordinator.path.isEmpty {
            coordinator.popToRoot()
        }

        coordinator.navigate(to: .searchObject)
    }
}

// MARK: - App Intent
/// # Manager - App Intent
/// Intent exposta à Siri e ao app Atalhos para abrir a tela de busca de objetos.
struct OpenSearchObjectSiriIntent: AppIntent {
    static var title: LocalizedStringResource = "intents.searchObject.title"
    static var description = IntentDescription("intents.searchObject.openSearch")

    /// Garante que o app seja trazido para o primeiro plano ao executar a intent.
    static var openAppWhenRun: Bool = true

    /// Define a ação do intents definido
    /// - Returns: um `IntentResult` que é o resultado de uma ação performada
    @MainActor
    func perform() async -> some IntentResult {
        IntentsManager.shared.openSearchObject()
        return .result()
    }
}

// MARK: - App Shortcuts Provider
/// # Manager - App Shortcuts
/// Prepara um shortcuts a partir do intent customizado recebido,
/// e define as frases de ativação da siri para utilização.
struct Challenge13Shortcuts: AppShortcutsProvider {
    /// Define um array de shortcuts, com apenas um no momento que é o intents de abrir o app na tela de procurar objeto
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: OpenSearchObjectSiriIntent(),
            phrases: [
                "Find my items with \(.applicationName)",
                "Search object with \(.applicationName)",
                "Open search in \(.applicationName)",
                "Find object in \(.applicationName)"
            ],
            shortTitle: "intents.searchObject.shortTitle",
            systemImageName: "magnifyingglass"
        )
    }
}
