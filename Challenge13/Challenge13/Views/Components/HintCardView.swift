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
        VStack() {
            
            // Título do card
            HStack (spacing: 12) {
                Image(systemName: hint.icon)
                    .font(.title)
                    .bold()
                
                Text(hint.title)
                    .font(.title2)
                    .bold()
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .font(.title)
                    .bold()
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .animation(.easeInOut, value: isExpanded)
            }
            .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
            
            // Conteúdo
            if isExpanded {

                Divider()
                .padding(.bottom, 4)
                .frame(maxWidth: .infinity)
                .overlay(Color.hintsPrimaryBorder)
                .padding(.horizontal, -16)

                Text(hint.description)
                    .padding(.top, 8)
                    .font(.subheadline)
                    .foregroundColor(.primary)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
        .background(Color(.hintsPrimary))
        .cornerRadius(12)
        .contentShape(Rectangle())
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.hintsPrimaryBorder, lineWidth: 4)
        )
        .onTapGesture {
            withAnimation(.easeInOut) {
                action()
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        
        HintCardView(
            hint: Hint(
                id: UUID(),
                title: "Adesivos",
                description: "Baixe a folha de adesivos e imprima. Cole nos objetos que deseja encontrar. A câmera do EyeSearch identifica os adesivos a até 2 metros e avisa quando o item for localizado.",
                icon: "printer.fill"
            ),
            isExpanded: true,
            action: {}
        )
        
    }
}

#Preview {
    VStack(spacing: 16) {
        
        HintCardView(
            hint: Hint(
                id: UUID(),
                title: "Adesivos",
                description: "Baixe a folha de adesivos e imprima. Cole nos objetos que deseja encontrar. A câmera do EyeSearch identifica os adesivos a até 2 metros e avisa quando o item for localizado.", 
                icon: "printer.fill"
            ),
            isExpanded: true,
            action: {}
        )
        .preferredColorScheme(.dark)
    }
}

