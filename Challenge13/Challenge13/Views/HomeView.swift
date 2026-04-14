//
//  ContentView.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 09/04/26.
//

import SwiftUI

struct HomeView: View {
    private let screenTitle = "Nome do app"
    
    private let items: [(title: String, icon: String, color: Color)] = [
        ("Pesquisar",     "magnifyingglass", Color("SearchGreen")),
        ("Monitorar",     "eye",             Color("StickerBlue")),
        ("Dicas",         "lightbulb.fill",  Color("HintsYellow")),
        ("Configurações", "gearshape.fill",  Color("SettingsPurple"))
    ]
    
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    private var usesLargeCard: Bool {
        dynamicTypeSize >= .xxxLarge // True quando o Dynamic Type está em xxxLarge ou maior
    }
 
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(items, id: \.title) { item in
                        Button { } label: {
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
//            .background(Color.black.ignoresSafeArea())
//            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

// MARK: - Previews

#Preview("xSmall") {
    HomeView()
        .environment(\.dynamicTypeSize, .xSmall)
}

#Preview("Large (padrão)") {
    HomeView()
        .environment(\.dynamicTypeSize, .large)
}

#Preview("xxLarge") {
    HomeView()
        .environment(\.dynamicTypeSize, .xxLarge)
}

#Preview("xxxLarge (compacto)") {
    HomeView()
        .environment(\.dynamicTypeSize, .xxxLarge)
}

#Preview("AX5 (compacto máximo)") {
    HomeView()
        .environment(\.dynamicTypeSize, .accessibility5)
}
