//
//  ContentView.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 09/04/26.
//

import SwiftUI

// MARK: - View
/// # View - HomeView
/// Tela principal do app que exibe os cards de navegação para as funcionalidades.
/// Adapta o layout dos cards conforme o Dynamic Type do usuário.
struct HomeView: View {
    // MARK: - Variables
    // Tamanho de fonte dinâmico do sistema (para adaptar layout)
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    // Coordinator para navegação entre telas
    @Environment(Coordinator.self) private var coordinator
    
    // Lista de itens do menu principal (carregada no onAppear)
    @State private var items: [(title: String, icon: String, color: Color, screen: HomeDestination)] = []
    
    var homeVM: HomeViewModel
    
    private let screenTitle = "Nome do app"
    // Decide se usa cards grandes (quando acessibilidade de texto grande está ativa)
    private var usesLargeCard: Bool {
        dynamicTypeSize >= .xxxLarge
    }
 
    // MARK: - Body View
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(items, id: \.title) { item in
                    Button {
                        // Navega para a tela correspondente ao card tocado
                        coordinator.navigate(to: item.screen)
                    } label: {
                        // Alterna entre card grande e compacto conforme Dynamic Type
                        if usesLargeCard {
                            BiggerCardView(title: item.title, icon: item.icon, color: item.color)
                        } else {
                            CompactCardView(title: item.title, icon: item.icon, color: item.color)
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(item.title)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .navigationTitle(screenTitle)
        .navigationBarTitleDisplayMode(.large)
        .onAppear {
            // Carrega os itens do menu ao aparecer na tela
            items = homeVM.generateItems()
        }
    }
}

// MARK: - Previews

#Preview("xSmall") {
    CoordinatedNavigationStack {
        HomeView(homeVM: HomeViewModel())
    }
    .environment(Coordinator(dependencyContainer: DependencyContainer()))
    .environment(\.dynamicTypeSize, .xSmall)
}

#Preview("Large (padrão)") {
    CoordinatedNavigationStack {
        HomeView(homeVM: HomeViewModel())
    }
    .environment(Coordinator(dependencyContainer: DependencyContainer()))
    .environment(\.dynamicTypeSize, .large)
}

#Preview("xxLarge") {
    CoordinatedNavigationStack {
        HomeView(homeVM: HomeViewModel())
    }
    .environment(Coordinator(dependencyContainer: DependencyContainer()))
    .environment(\.dynamicTypeSize, .xxLarge)
}
