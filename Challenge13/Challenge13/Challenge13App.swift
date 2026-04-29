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

    // Flag de primeira execução: enquanto false, exibe o onboarding em vez da Home.
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false

    // Controla exibição da splash — true até a animação terminar
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            if showSplash {
                SplashView {
                    showSplash = false
                }
            } else if hasCompletedOnboarding {
                // Para o coordinator receber a view raiz e fazer sua estrutura de navigationStack
                CoordinatedNavigationStack {
                    HomeView(homeVM: coordinator.dependencyContainer.homeViewModel)
                }
                // Coordinator injetado como variável de ambiente
                .environment(coordinator)
                .task {
                    IntentsManager.shared.coordinator = coordinator
                }
                .onOpenURL { url in
                    if url.scheme == "eyesearch" {
                        IntentsManager.shared.openSearchObject()
                    }
                }
            } else {
                CoordinatedNavigationStack {
                    OnboardingView()
                }
                // Coordinator injetado como variável de ambiente
                .environment(coordinator)
                .task {
                    IntentsManager.shared.coordinator = coordinator
                }
                .onOpenURL { url in
                    if url.scheme == "eyesearch" && url.host == "searchObject" {
                        IntentsManager.shared.openSearchObject()
                    }
                }
                        .onOpenURL { url in
                            if url.scheme == "eyesearch" && url.host == "searchObject" {
                                IntentsManager.shared.openSearchObject()
                            }
                        }
                }
        }
    }
}
