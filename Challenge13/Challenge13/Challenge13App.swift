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
/// Configura o `Coordinator`, o `DependencyContainer` e o `ModelContainer` do SwiftData.
@main
struct Challenge13App: App {
    /// Container do SwiftData para persistência de dados.
    var sharedModelContainer: ModelContainer = {
        // Define o schema (modelos de dados) — vazio por enquanto
        let schema = Schema([
            
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    // Coordinator principal do app, gerencia toda a navegação
    @State private var coordinator = Coordinator(dependencyContainer: DependencyContainer())

    var body: some Scene {
        WindowGroup {
            // Para o coordinator receber a view raiz e fazer sua estrutura de navigationStack
            CoordinatedNavigationStack {
                HomeView(homeVM: coordinator.dependencyContainer.homeViewModel)
            }
            // Coordinator injetado como variável de ambiente
            .environment(coordinator)
        }
        .modelContainer(sharedModelContainer)
    }
}
