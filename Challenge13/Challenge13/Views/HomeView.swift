//
//  ContentView.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 09/04/26.
//

import SwiftUI
import SwiftData

enum HomeDestination: Hashable {
    case searchObject
    case sticker
    case hints
    case settings
}

struct HomeView: View {

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                NavigationLink("Buscar Objeto", value: HomeDestination.searchObject)
                NavigationLink("Sticker", value: HomeDestination.sticker)
                NavigationLink("Dicas", value: HomeDestination.hints)
                NavigationLink("Configurações", value: HomeDestination.settings)
            }
            .navigationTitle("Home")
            .navigationDestination(for: HomeDestination.self) { destination in
                switch destination {
                case .searchObject:
                    SearchObjectView()
                case .sticker:
                    StickerView()
                case .hints:
                    HintsView()
                case .settings:
                    SettingsView()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
