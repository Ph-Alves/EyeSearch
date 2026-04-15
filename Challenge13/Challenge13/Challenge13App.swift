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
    
    @State private var coordinator = Coordinator()

    var body: some Scene {
        WindowGroup {
            CoordinatedNavigationStack {
                HomeView()
            }
            .environment(coordinator)
        }
        .modelContainer(sharedModelContainer)
    }
}
