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
    
    @State private var items: [(title: String, icon: String, color: Color, screen: HomeDestination)] = []
    
    var homeVM: HomeViewModel
    
    private let screenTitle = "Nome do app"
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
        .onAppear() {
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
