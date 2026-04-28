//
//  HintsView.swift
//  Challenge13
//
//  Created by Daniela Valadares on 09/04/26.
//

import SwiftUI

// MARK: - View
/// # View - HintsView
/// Tela de dicas de acessibilidade com cards expansíveis.
/// Exibe uma lista de dicas que o usuário pode tocar para expandir e ver o conteúdo completo.
struct HintsView: View {
    // MARK: - Variables
    @Environment(Coordinator.self) private var coordinator
    @State private var viewModel = HintsViewModel()
    
    // MARK: - Body View
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 16) {
                    
                    // Botão voltar
                    ReturnButton {
                        coordinator.pop()
                    }
                    
                    // Título + subtítulo
                    VStack(alignment: .leading, spacing: 8) {
                        Text(verbatim: .localized(L10n.Hints.Screen.title))
                            .fontWeight(.semibold)
                            .font(.largeTitle)
                            .padding(.bottom, 10)

                        Text(verbatim: .localized(L10n.Hints.Screen.description))
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 20)
                    
                    // Lista de cards de Hints
                    VStack(spacing: 16) {
                        ForEach(viewModel.hints) { hint in
                            HintCardView(
                                hint: hint,
                                isExpanded: viewModel.selectedHintID == hint.id,
                                action: {
                                    viewModel.toggleHint(hint)
                                }
                            )
                            .padding(.bottom, 20)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(verbatim: .localized(L10n.Hints.Screen.chatTitle))
                            .fontWeight(.semibold)
                            .font(.largeTitle)
                            .padding(.bottom, 10)

                        Text(verbatim: .localized(L10n.Hints.Screen.chatDescription))
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    .padding(.bottom, 20)
                    .frame(maxWidth: .infinity, alignment: .leading) // ← mesmo aqui
                    
                    // Card para o AIChat
                    AIChatCardView()
                        
                }
                .padding(.horizontal, 20) // ← só aqui, uma vez só
                .padding(.top)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview
#Preview {
    CoordinatedNavigationStack {
        HintsView()
    }
    .environment(Coordinator(dependencyContainer: DependencyContainer()))
}

#Preview {
    CoordinatedNavigationStack {
        HintsView()
    }
    .environment(Coordinator(dependencyContainer: DependencyContainer()))
    .preferredColorScheme(.dark)
}
