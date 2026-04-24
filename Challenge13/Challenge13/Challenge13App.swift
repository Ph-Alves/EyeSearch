//
//  Challenge13App.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 09/04/26.
//

import SwiftUI
import SwiftData

// MARK: - App
/// # App - Challenge13App
/// Ponto de entrada principal do app EyeSearch.
/// Configura o ``Coordinator``, o ``DependencyContainer``, e prepara o ``IntentsManager``.
@main
struct Challenge13App: App {
    
    // Coordinator principal do app, gerencia toda a navegação
    @State private var coordinator = Coordinator(dependencyContainer: DependencyContainer())

    var body: some Scene {
        WindowGroup {
            // Para o coordinator receber a view raiz e fazer sua estrutura de navigationStack
            CoordinatedNavigationStack {
                HomeView(homeVM: coordinator.dependencyContainer.homeViewModel)
            }
            .onOpenURL { url in
                if url.scheme == "eyesearch" && url.host == "searchObject" {
                    IntentsManager.shared.openSearchObject()
                }
            }
            // Coordinator injetado como variável de ambiente
            .environment(coordinator)
            // Expõe o coordinator ao IntentsManager para que os AppIntents (Siri)
            // possam disparar navegações seguindo o padrão do Coordinator.
            .task {
                IntentsManager.shared.coordinator = coordinator
            }
        }
    }
}
