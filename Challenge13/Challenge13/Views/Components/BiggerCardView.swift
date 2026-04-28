//
//  BiggerCardView.swift
//  Challenge13
//
//  Created by Daniela Valadares on 11/04/26.
//

import SwiftUI

// MARK: - Component
/// # Component - BiggerCardView
/// Card de navegação com layout vertical (ícone em cima, título embaixo).
/// Usado na `HomeView` quando o Dynamic Type é `xxxLarge` ou maior.
struct BiggerCardView: View {
    /// Título exibido no card.
    let title: String
    /// Nome do SF Symbol exibido no card.
    let icon: String
    /// Cor de fundo do card.
    let color: Color
    /// Cor da borda do card.
    let borderColor: Color

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.titleText)
                .padding(.bottom, 16)
                
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.titleText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 283)
        .padding(.vertical, 34)
        .background(color)
        .cornerRadius(22)
        .contentShape(Rectangle())
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color(borderColor), lineWidth: 8)
        )
    }
}

#Preview {
    BiggerCardView(title: "Settings", icon: "iphone.radiowaves.left.and.right", color: Color(.searchPrimary), borderColor: .searchPrimaryBorder)
}
