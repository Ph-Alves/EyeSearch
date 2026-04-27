//
//  ReturnButton.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 15/04/26.
//

import SwiftUI

// MARK: - Component
/// # Component - ReturnButton
/// Botão de retorno reutilizável com ícone de chevron e texto "Voltar".
/// Usado em todas as telas internas para navegação de volta.
struct ReturnButton: View {
    // MARK: - Variables
    /// Ação executada ao tocar no botão.
    var action: () -> Void
    /// Texto exibido no botão.
    let returnText: String = "Voltar"
    
    // MARK: - Body view
    var body: some View {
        VStack (alignment: .leading, spacing: 12) {
            Button(action: action, label: {
                HStack {
                    Image(systemName: "chevron.left")
                        .fontWeight(.bold)
                    Text(returnText)
                        .font(.title)
                        .fontWeight(.bold)
                }
            })
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 12)
        .padding(.bottom, 24)
    }
}



// MARK: - Preview
#Preview {
    ReturnButton(action: {})
}
