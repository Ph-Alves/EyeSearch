//
//  HintCardView.swift
//  Challenge13
//
//  Created by Raquel Souza on 17/04/26.
//

import SwiftUI

// MARK: - Component
/// # Component - HintCardView
/// Card expansível que exibe uma dica de acessibilidade.
/// Ao ser tocado, expande para mostrar a descrição completa da dica.
/// ## Usado em:
/// - ``HintsView``
struct HintCardView: View {
    /// Dados da dica a ser exibida.
    let hint: Hint
    /// Indica se o card está expandido (mostrando a descrição).
    let isExpanded: Bool
    /// Ação executada ao tocar no card.
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // Título
            HStack {
                Text(hint.title)
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .animation(.easeInOut, value: isExpanded)
            }
            
            // Conteúdo
            if isExpanded {
                Text(hint.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut) {
                print("clicou no card")
                action()
            }
        }
    }
}
