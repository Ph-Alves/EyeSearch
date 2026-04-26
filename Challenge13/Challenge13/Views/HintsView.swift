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
                        Text("Dicas")
                            .font(.largeTitle)
                        
                        Text("Lorem Ipsum Dolor Sit Amet Dolor Sit Sit Amet Dolor Sit")
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                    .padding(.top, 8)
                    
                    // Card para o AIChat, ainda não funcionando.
                    AIChatCardView()
                        .padding(.top, 28)
                    
                    Text("Tire dúvidas com a IA")
                        .padding(.top, 8)
                    
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
                        }
                    }
                }
                .padding(.horizontal, 20)
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
