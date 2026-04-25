//
//  OnboardingContinueButton.swift
//  Challenge13
//
//  Created by Manoel Pedro Prado Sa Teles on 24/04/26.
//

import SwiftUI

// MARK: - Component
/// # Component - OnboardingContinueButton
/// Botão pill (cápsula arredondada) usado no rodapé do onboarding para
/// avançar entre páginas ou finalizar o fluxo. Fundo usa `titleText` e
/// texto usa `background`, fazendo as cores inverterem automaticamente
/// entre modo claro (fundo preto / texto creme) e escuro (fundo creme /
/// texto preto).
/// ## Usado em:
/// - ``OnboardingView``
struct OnboardingContinueButton: View {
    // MARK: - Variables
    /// Texto exibido no botão ("Continuar" ou "Começar").
    let title: String
    /// Ação executada ao tocar no botão.
    let action: () -> Void

    // MARK: - Body View
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color("background"))
                .frame(width: 215, height: 45)
                .background(
                    RoundedRectangle(cornerRadius: 22.5, style: .continuous)
                        .fill(Color("titleText"))
                )
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        OnboardingContinueButton(title: "Continuar") {}
        OnboardingContinueButton(title: "Começar") {}
    }
    .padding(32)
    .background(Color("background"))
}
