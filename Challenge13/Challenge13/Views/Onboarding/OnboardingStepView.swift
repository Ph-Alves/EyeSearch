//
//  OnboardingStepView.swift
//  Challenge13
//
//  Created by Manoel Pedro Prado Sa Teles on 24/04/26.
//

import SwiftUI

// MARK: - View
/// # View - OnboardingStepView
/// Layout de uma página individual do onboarding, com título no topo,
/// imagem ilustrativa no centro e descrição abaixo. O tipo de imagem
/// (composta, com borda, simples ou nenhuma) é decidido pelo enum
/// ``OnboardingPageImage`` contido no modelo recebido.
/// ## Usado em:
/// - ``OnboardingView``
struct OnboardingStepView: View {
    // MARK: - Variables
    /// Dados da página a ser exibida.
    let page: OnboardingPage

    // MARK: - Body View
    var body: some View {
        VStack(spacing: 0) {
            // Título - fonte bold maior
            Text(page.title)
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(Color("titleText"))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: 340)

            Spacer(minLength: 24)

            // Imagem ilustrativa, renderizada conforme o caso do enum
            imageContent

            Spacer(minLength: 24)

            // Corpo descritivo da tela
            Text(page.body)
                .font(.system(size: 20))
                .foregroundStyle(Color("titleText"))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: 306)
        }
        .padding(.horizontal, 24)
        .padding(.top, 32)
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Subviews
    /// Renderiza o conteúdo de imagem de acordo com o tipo declarado na página.
    /// Cada caso usa o mesmo frame de 326×326 para manter rítmo visual consistente.
    @ViewBuilder
    private var imageContent: some View {
        switch page.image {
        case .mp1Composite:
            OnboardingMP1Image()
        case .bordered(let name):
            Image(name)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 326, height: 326)
                .clipped()
                .overlay(
                    Rectangle()
                        .strokeBorder(Color("titleText"), lineWidth: 6)
                )
        case .plain(let name):
            Image(name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 326, height: 326)
        case .none:
            Color.clear
                .frame(width: 326, height: 326)
        }
    }
}

// MARK: - Private Component
/// # Component - OnboardingMP1Image
/// Composição exclusiva da tela 1: desenho da mão segurando o celular
/// (base) + foto do app rodando (overlay) posicionada dentro da silhueta
/// desenhada. Offsets medidos no Figma (frame 149:318) relativos ao
/// container de 326×326.
private struct OnboardingMP1Image: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Base: desenho da mão segurando o celular
            Image("onboarding_mp1_hand")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 326, height: 326)

            // Overlay: foto do app posicionada dentro do celular desenhado
            Image("onboarding_mp1_phone")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 81, height: 177)
                .clipped()
                .offset(x: 91, y: 124)
        }
        .frame(width: 326, height: 326)
    }
}

// MARK: - Previews
#Preview("Step 1") {
    OnboardingStepView(page: OnboardingPage.all[0])
        .background(Color("background"))
}

#Preview("Step 4 (no image)") {
    OnboardingStepView(page: OnboardingPage.all[3])
        .background(Color("background"))
}
