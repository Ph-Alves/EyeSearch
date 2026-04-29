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
    ///Cor da borda do card
    let borderColor: Color
    
    @ScaledMetric(relativeTo: .title) private var minHeight: CGFloat = 100
    @ScaledMetric(relativeTo: .title) private var horizontalPadding: CGFloat = 32.5
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.titleText)
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.titleText)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .padding(.horizontal, horizontalPadding)
        .frame(maxWidth: .infinity, minHeight: minHeight)
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
    CompactCardView(title: "Settings", icon: "iphone.radiowaves.left.and.right", color: Color(.settingsPrimary), borderColor: Color(.settingsPrimaryBorder))
}
