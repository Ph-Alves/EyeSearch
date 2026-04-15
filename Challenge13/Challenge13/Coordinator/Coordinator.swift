//
//  baseCoordinator.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 09/04/26.
//

import Foundation
import SwiftUI

// O enum define os pontos de navegação
enum HomeDestination: Hashable {
    case searchObject
    case sticker
    case hints
    case settings
}

// Coordinator observável, para manter a view reativa
@Observable
class Coordinator {
    // Caminho de navegação
    var path = NavigationPath()
    
    // Adiciona a pilha de navegação o enum do destination
    func navigate(to destination: HomeDestination) {
        path.append(destination)
    }
    
    // Retira do topo da pilha (view mais recente)
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }
    
    // Retira tudo da pilha, indo para a home
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    // Isso garante que vai sempre retornar uma estrutura que conforma com o protocolo View
    // Sem isso o compilador reclama falando que são "tipos diferentes"
    // some View é um tipo opaco que fala -> o que vai retornar aqui é qualquer estrutura que conforma com View§
    @ViewBuilder
    func destination(for destination: HomeDestination) -> some View {
        switch destination {
        case .searchObject : SearchObjectView()
        case .sticker : StickerView()
        case .hints : HintsView()
        case .settings : SettingsView()
        }
    }
}

// Isso é uma view genérica, ou seja possui um valor genérico que deve ser recebido,
// onde o <Content: View> define que aceita qualquer View como conteúdo
// o @ViewBuilder var content é o conteúdo de view que vai ser usado e que vai dentro do navigationStack
// Usamos o mesmo método para montar modificadores de fonte personalizados
struct CoordinatedNavigationStack<Content: View>: View {
    @Environment(Coordinator.self) private var coordinator
    @ViewBuilder var content: Content

    var body: some View {
        @Bindable var coordinator = coordinator
        NavigationStack(path: $coordinator.path) {
            content
                .navigationDestination(for: HomeDestination.self) { destination in
                    coordinator.destination(for: destination)
                }
        }
    }
}
