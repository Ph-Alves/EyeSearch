//
//  OnboardingProgressBar.swift
//  Challenge13
//
//  Created by Manoel Pedro Prado Sa Teles on 24/04/26.
//

import SwiftUI

// MARK: - Component
/// # Component - OnboardingProgressBar
/// Indicador de progresso horizontal com múltiplos segmentos de largura
/// flexível. Segmentos até o índice atual ficam preenchidos com a cor
/// do texto (`titleText`), e os restantes ficam com cinza suave
/// (`onboardingProgressInactive`) — ambos adaptam ao modo claro/escuro.
/// ## Usado em:
/// - ``OnboardingView``
struct OnboardingProgressBar: View {
    // MARK: - Variables
    /// Índice da página atualmente ativa (0 baseado).
    let currentIndex: Int
    /// Total de páginas/segmentos a exibir.
    let totalSteps: Int

    // MARK: - Body View
    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<totalSteps, id: \.self) { index in
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    // Segmento ativo se o índice já foi atingido, inativo caso contrário
                    .fill(index <= currentIndex ? Color("titleText") : Color("onboardingProgressInactive"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 8)
            }
        }
        // Anima o preenchimento dos segmentos quando o usuário avança
        .animation(.easeInOut(duration: 0.25), value: currentIndex)
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        OnboardingProgressBar(currentIndex: 0, totalSteps: 5)
        OnboardingProgressBar(currentIndex: 2, totalSteps: 5)
        OnboardingProgressBar(currentIndex: 4, totalSteps: 5)
    }
    .padding(.horizontal, 22)
    .padding(.vertical, 32)
    .background(Color("background"))
}
