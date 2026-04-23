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
        VStack {
            
            // Volta a view anterior
            ReturnButton(action: {
                coordinator.pop()
            })
            Text("Hints View")
            Button {
                coordinator.navigate(to: HomeDestination.chat)
            } label: {
                Text("CHATBOT")
                    .bold()
                
                ScrollView {
                    VStack(spacing: 12) {
                        
                        ForEach(viewModel.hints) { hint in
                            HintCardView(
                                hint: hint,
                                isExpanded: viewModel.selectedHintID == hint.id,
                                action: {
                                    print("clicou no texto")
                                    viewModel.toggleHint(hint)
                                }
                            )
                        }
                        
                    }
                    .padding()
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}

// MARK: - Preview
#Preview {
    CoordinatedNavigationStack {
        HintsView()
    }
    .environment(Coordinator(dependencyContainer: DependencyContainer()))
    .environment(\.dynamicTypeSize, .large)
}
