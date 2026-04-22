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
    let returnText: String = String(localized: "common.button.back")
    
    // MARK: - Body view
    var body: some View {
        Button(action: action, label: {
            HStack {
                Image(systemName: "chevron.left")
                    .fontWeight(.bold)
                Text(returnText)
                    .fontWeight(.bold)
            }
        })
    }
}

// MARK: - Preview
#Preview {
    ReturnButton(action: {})
}
