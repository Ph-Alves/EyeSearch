//
//  CompactCardView.swift
//  Challenge13
//
//  Created by Daniela Valadares on 11/04/26.
//

import SwiftUI

// MARK: - Component
/// # Component - CompactCardView
/// Card de navegação com layout horizontal (ícone à esquerda, título à direita).
/// Usado na `HomeView` quando o Dynamic Type é menor que `xxxLarge`.
struct CompactCardView: View {
    /// Título exibido no card.
    let title: String
    /// Nome do SF Symbol exibido no card.
    let icon: String
    /// Cor de fundo do card.
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 25, weight: .regular))
                .foregroundColor(.white)
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 64)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}
// medidas ainda a refinar com o protótipo de alta
