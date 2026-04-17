//
//  ContentView.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 09/04/26.
//

import SwiftUI

struct HomeView: View {
    // MARK: - Variables
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @Environment(Coordinator.self) private var coordinator
    
    private let screenTitle = "Nome do app"
    private let items: [(title: String, icon: String, color: Color, screen: HomeDestination)] = [
        ("Procurar",     "magnifyingglass", Color("SearchGreen"),    HomeDestination.searchObject),
        ("Gerar",        "eye",             Color("StickerBlue"),    HomeDestination.stickerConfig),
        ("Dicas",        "lightbulb.fill",  Color("HintsYellow"),    HomeDestination.hints),
        ("Configurações", "gearshape.fill", Color("SettingsPurple"), HomeDestination.settings)
    ]
    private var usesLargeCard: Bool {
        dynamicTypeSize >= .xxxLarge // True quando o Dynamic Type está em xxxLarge ou maior
    }
 
    // MARK: - Body View
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(items, id: \.title) { item in
                    Button {
                        coordinator.navigate(to: item.screen)
                    } label: {
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
    }
}

// MARK: - Previews

#Preview("xSmall") {
    CoordinatedNavigationStack {
        HomeView()
    }
    .environment(Coordinator())
    .environment(\.dynamicTypeSize, .xSmall)
}

#Preview("Large (padrão)") {
    CoordinatedNavigationStack {
        HomeView()
    }
    .environment(Coordinator())
    .environment(\.dynamicTypeSize, .large)
}

#Preview("xxLarge") {
    CoordinatedNavigationStack {
        HomeView()
    }
    .environment(Coordinator())
    .environment(\.dynamicTypeSize, .xxLarge)
}

#Preview("xxxLarge (compacto)") {
    CoordinatedNavigationStack {
        HomeView()
    }
    .environment(Coordinator())
    .environment(\.dynamicTypeSize, .xxxLarge)
}

#Preview("AX5 (compacto máximo)") {
    CoordinatedNavigationStack {
        HomeView()
    }
    .environment(Coordinator())
    .environment(\.dynamicTypeSize, .accessibility5)
}
