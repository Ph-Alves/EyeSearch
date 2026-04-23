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
    
    /// Instância compartilhada para ser acessada dentro de AppIntents,
    /// já que AppIntents são instanciados pelo sistema e não têm acesso ao Environment.
    static let shared = IntentsManager()

    /// Referência fraca ao Coordinator para evitar ciclo de retenção.
    weak var coordinator: Coordinator?

    private init() { }

    /// Navega até a SearchObjectView respeitando o padrão do ``Coordinator``.
    @MainActor
    func openSearchObject() {
        guard let coordinator else { return }

        if !coordinator.path.isEmpty {
            coordinator.popToRoot()
        }

        coordinator.navigate(to: .searchObject)
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
