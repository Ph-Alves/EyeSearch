//
//  baseCoordinator.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 09/04/26.
//

import Foundation
import SwiftUI

// MARK: - Enum
/// # Enum - HomeDestination
/// Define os destinos de navegação disponíveis a partir da tela principal.
/// Cada case representa uma tela do app acessível via ``Coordinator``.
enum HomeDestination: Hashable {
    /// Tela de busca de objetos adesivados com câmera.
    case searchObject
    /// Tela de configuração para geração de adesivos (selecionar quantidade).
    case stickerConfig
    /// Tela de preview e exportação do PDF de adesivos.
    case stickerPreview
    /// Tela de dicas de acessibilidade.
    case hints
    /// Tela de configurações do app (haptics, som).
    case settings
    case chat
}

// MARK: - Coordinator
/// # Coordinator
/// Gerencia a navegação do app usando `NavigationPath`.
/// Usa `Observable` para manter a view reativa às mudanças de navegação.
/// ## Usado em:
/// - ``Challenge13App``
/// - Todas as views (via `@Environment`)
@Observable
class Coordinator {
    // MARK: - Variables
    /// Pilha de navegação do app.
    var path = NavigationPath()
    /// Container de dependências com as ViewModels pré-configuradas.
    var dependencyContainer: DependencyContainer
    
    // MARK: - Init
    /// Inicializa o coordinator com o container de dependências.
    /// - Parameter dependencyContainer: Container com as ViewModels injetadas.
    init(dependencyContainer: DependencyContainer) {
        self.dependencyContainer = dependencyContainer
    }
    
    // MARK: - Functions
    /// Navega para o destino especificado, adicionando-o à pilha de navegação.
    /// - Parameter destination: O destino de navegação, usando o enum ``HomeDestination`` de base.
    func navigate(to destination: HomeDestination) {
        path.append(destination)
    }
    
    /// Retira a view do topo da pilha (volta uma tela).
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    /// Remove todas as views da pilha, retornando à tela principal (home).
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    /// Resolve o destino de navegação retornando a view correspondente.
    /// - Parameter destination: O destino a ser resolvido.
    /// - Returns: A view correspondente ao destino.
    @ViewBuilder
    func destination(for destination: HomeDestination) -> some View {
        switch destination {
        case .searchObject : SearchObjectView(SearchObjectVM: dependencyContainer.searchViewModel)
        case .stickerConfig : StickerView(stickerVM: dependencyContainer.stickerViewModel)
        case .stickerPreview : PrintStickerView(stickerVM: dependencyContainer.stickerViewModel)
        case .hints : HintsView()
        case .settings : SettingsView(settingsVM: dependencyContainer.settingsViewModel)
        case .chat : ChatView(viewModel: ChatViewModel(manager: dependencyContainer.foundationsManager, coordinator: self))
        }
    }
}

// MARK: - CoordinatedNavigationStack
/// # View - CoordinatedNavigationStack
/// View genérica que encapsula um `NavigationStack` gerenciado pelo ``Coordinator``.
/// Aceita qualquer conteúdo `View` e configura automaticamente os destinos de navegação.
/// ## Usado em:
/// - ``Challenge13App``
/// - Previews de todas as views
struct CoordinatedNavigationStack<Content: View>: View {
    /// Coordinator injetado via Environment.
    @Environment(Coordinator.self) private var coordinator
    /// Conteúdo da view raiz do NavigationStack.
    @ViewBuilder var content: Content

    var body: some View {
        // O environment permite a leitura somente, com o bindable, permitimos a escrita também, por causa do .path
        @Bindable var coordinator = coordinator
        NavigationStack(path: $coordinator.path) {
            content
                .navigationDestination(for: HomeDestination.self) { destination in
                    coordinator.destination(for: destination)
                }
        }
    }
}
