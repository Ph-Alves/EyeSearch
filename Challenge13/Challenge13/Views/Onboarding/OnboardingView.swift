//
//  OnboardingView.swift
//  Challenge13
//
//  Created by Manoel Pedro Prado Sa Teles on 24/04/26.
//

import SwiftUI

// MARK: - View
/// # View - OnboardingView
/// Tela raiz do onboarding, exibida apenas na primeira execução do app.
/// Apresenta 5 páginas em sequência usando `TabView` com swipe horizontal,
/// progress bar no topo e botão de avanço no rodapé. Na última página, o
/// botão conclui o fluxo e marca `hasCompletedOnboarding` como `true`,
/// fazendo o app trocar automaticamente para a ``HomeView``.
/// ## Usado em:
/// - ``Challenge13App``
struct OnboardingView: View {
    // MARK: - Variables
    /// Flag de persistência da conclusão do onboarding.
    /// Quando `true`, o app pula o fluxo nas próximas aberturas.
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    /// Índice da página atualmente exibida (0...4).
    @State private var currentPage: Int = 0
    /// Lista estática das páginas do onboarding.
    private let pages = OnboardingPage.all

    // MARK: - Body View
    var body: some View {
        ZStack {
            // Fundo adapta ao modo claro/escuro via token do Assets.
            Color("background")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Progress bar de 5 segmentos, preenche conforme avança.
                OnboardingProgressBar(currentIndex: currentPage, totalSteps: pages.count)
                    .padding(.horizontal, 22)
                    .padding(.top, 16)

                // TabView paginado permite swipe horizontal nativo entre as telas.
                // indexDisplayMode: .never esconde o indicador padrão — usamos o próprio.
                TabView(selection: $currentPage) {
                    ForEach(pages) { page in
                        OnboardingStepView(page: page)
                            .tag(page.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .accessibilityIdentifier("onboarding_tabview")

                // Botão avança a página ou finaliza o onboarding na última.
                OnboardingContinueButton(title: pages[currentPage].buttonTitle) {
                    advance()
                }
                .padding(.bottom, 32)
            }
        }
    }

    // MARK: - Functions
    /// Avança para a próxima página ou finaliza o onboarding.
    /// Na última página, persiste a flag e deixa o ``Challenge13App``
    /// reagir trocando a raiz para a ``HomeView``.
    private func advance() {
        if currentPage < pages.count - 1 {
            withAnimation(.easeInOut(duration: 0.25)) {
                currentPage += 1
            }
        } else {
            hasCompletedOnboarding = true
        }
    }
}

// MARK: - Preview
#Preview {
    OnboardingView()
}
