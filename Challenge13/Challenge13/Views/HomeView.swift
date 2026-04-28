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
    @State private var items: [(title: String, icon: String, color: Color, borderColor: Color, screen: HomeDestination)] = []
    
    var homeVM: HomeViewModel
    
    private let screenTitle = "EyeSearch"
    // Decide se usa cards grandes (quando acessibilidade de texto grande está ativa)
    private var usesLargeCard: Bool {
        dynamicTypeSize >= .xxxLarge
    }
    
    private var content: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            
            VStack {
                VStack(alignment: .leading, spacing: 12){
                    //título da tela
                    Text("EyeSearch")
                        .fontWeight(.bold)
                        .font(.largeTitle)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 12)
                .padding(.bottom, 24)
                
                VStack(spacing: 24) {
                    ForEach(homeVM.generateItems(), id: \.title) { item in
                        Button {
                            // Navega para a tela correspondente ao card tocado
                            coordinator.navigate(to: item.screen)
                        } label: {
                            // Alterna entre card grande e compacto conforme Dynamic Type
                            if usesLargeCard {
                                BiggerCardView(title: item.title, icon: item.icon, color: item.color, borderColor: item.borderColor)
                            } else {
                                CompactCardView(title: item.title, icon: item.icon, color: item.color, borderColor: item.borderColor)
                            }
                        }
                        .accessibilityLabel(item.title)
                    }
                }
                
                Spacer()
            }
            .padding(.horizontal, 28.5)
            
        }
    }
    
    // MARK: - Body View
    var body: some View {
        
        if dynamicTypeSize >= .xxxLarge {
            ScrollView {
                content
            }
            .background(Color(.background).ignoresSafeArea())
        } else {
            content
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

#Preview("xxxLarge") {
    CoordinatedNavigationStack {
        HomeView(homeVM: HomeViewModel())
    }
    .environment(Coordinator(dependencyContainer: DependencyContainer()))
    .environment(\.dynamicTypeSize, .xxxLarge)
}
