//
//  Challenge13App.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 09/04/26.
//

import SwiftUI
import SwiftData

@main
struct Challenge13App: App {
    // Config do banco de dados
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @State private var coordinator = Coordinator(dependencyContainer: DependencyContainer())

    var body: some Scene {
        WindowGroup {
            // Para o coordinator receber a view raiz e fazer sua estrutura de navigationStack
            CoordinatedNavigationStack {
                HomeView(homeVM: coordinator.dependencyContainer.homeViewModel)
            }
            // Coordinator injetado como variável de ambiente
            .environment(coordinator)
            // Expõe o coordinator ao IntentsManager para que os AppIntents (Siri)
            // possam disparar navegações seguindo o padrão do Coordinator.
            .task {
                IntentsManager.shared.coordinator = coordinator
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
