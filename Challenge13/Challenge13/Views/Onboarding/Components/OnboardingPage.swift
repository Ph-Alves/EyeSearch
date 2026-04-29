//
//  OnboardingPage.swift
//  Challenge13
//
//  Created by Manoel Pedro Prado Sa Teles on 24/04/26.
//

import Foundation

// MARK: - Model
/// # Model - OnboardingPageImage
/// Tipo de imagem exibida numa página do onboarding.
/// Permite alternar entre composição especial (mão + celular da tela 1),
/// imagem com borda (ícone do marcador), imagem simples ou nenhuma imagem.
/// ## Usado em:
/// - ``OnboardingPage``
/// - ``OnboardingStepView``
enum OnboardingPageImage: Equatable {
    /// Composição da tela 1: fundo (mão desenhada) + overlay (foto do celular).
    case mp1Composite
    /// Imagem centralizada com borda branca/preta (tela 2 - marcador).
    case bordered(String)
    /// Imagem centralizada sem borda (telas 3 e 5).
    case plain(String)
    /// Sem imagem (tela 4 - atalho Siri).
    case none
}

// MARK: - Model
/// # Model - OnboardingPage
/// Modelo de dados para cada tela do onboarding, com título, descrição,
/// imagem e texto do botão. Usa `Identifiable` para permitir uso em `ForEach`
/// e `Equatable` para permitir comparações de valor.
/// ## Usado em:
/// - ``OnboardingView``
/// - ``OnboardingStepView``
struct OnboardingPage: Identifiable, Equatable {
    /// Índice da página (0...4). Também serve como tag do `TabView`.
    let id: Int
    /// Título principal exibido no topo da página.
    let title: String
    /// Texto descritivo exibido abaixo da imagem.
    let body: String
    /// Imagem ilustrativa da página (ou `.none` na tela 4).
    let image: OnboardingPageImage
    /// Texto do botão de avanço ("Continuar" ou "Começar" na última).
    let buttonTitle: String
}

// MARK: - Conteúdo estático
/// Lista fixa das 5 páginas do onboarding, na ordem de apresentação.
/// Mantida como estática porque o conteúdo é invariável em runtime.
extension OnboardingPage {
    static let all: [OnboardingPage] = [
        .init(
            id: 0,
            title: "Encontre seus objetos com facilidade",
            body: "O EyeSearch ajuda você a localizar objetos usando a câmera do seu celular.",
            image: .mp1Composite,
            buttonTitle: "Continuar"
        ),
        .init(
            id: 1,
            title: "Este é seu marcador",
            body: "Cole em qualquer objeto que você queira encontrar. O EyeSearch reconhece e avisa quando ele for encontrado.",
            image: .bordered("onboarding_mp2"),
            buttonTitle: "Continuar"
        ),
        .init(
            id: 2,
            title: "Imprima seus adesivos",
            body: "Baixe a folha de adesivos, imprima em casa ou em uma gráfica, e recorte. Pronto pra usar em qualquer objeto.",
            image: .plain("onboarding_mp3"),
            buttonTitle: "Continuar"
        ),
        .init(
            id: 3,
            title: "É só pedir pra Siri",
            body: "Diga 'Ei Siri, encontrar meus objetos' e o EyeSearch abre pronto pra buscar.",
            image: .none,
            buttonTitle: "Continuar"
        ),
        .init(
            id: 4,
            title: "Dicas e ajuda quando precisar",
            body: "Explore dicas dentro do app ou converse com o assistente de IA pra aprender mais.",
            image: .plain("onboarding_mp5"),
            buttonTitle: "Começar"
        )
    ]
}
