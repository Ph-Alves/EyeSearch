//
//  OnboardingPage.swift
//  Challenge13
//
//  Created by Manoel Pedro Prado Sa Teles on 24/04/26.
//

import Foundation

enum OnboardingPageImage: Equatable {
    case mp1Composite
    case bordered(String)
    case plain(String)
    case none
}

struct OnboardingPage: Identifiable, Equatable {
    let id: Int
    let title: String
    let body: String
    let image: OnboardingPageImage
    let buttonTitle: String
}

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
