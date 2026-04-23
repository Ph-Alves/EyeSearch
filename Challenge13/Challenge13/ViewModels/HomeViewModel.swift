//
//  HomeViewModel.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 17/04/26.
//

import Foundation
import SwiftUI

// MARK: - ViewModel
/// # ViewModel - HomeViewModel
/// ViewModel da tela principal do app.
/// Responsável por gerar os itens de navegação exibidos na `HomeView`.
/// ## Usado em:
/// - ``HomeView``
@Observable
class HomeViewModel {
    // MARK: - Init
    init() {}
    
    // MARK: - Functions
    /// Gera a lista de itens do menu principal com título, ícone, cor e destino de navegação.
    /// - Returns: Array de tuplas representando cada item da home.
    func generateItems() -> [(title: String, icon: String, color: Color, screen: HomeDestination)] {
        return [
            (String(localized: String.LocalizationValue(L10n.Home.Menu.search)),   "magnifyingglass", Color("SearchGreen"),    HomeDestination.searchObject),
            (String(localized: String.LocalizationValue(L10n.Home.Menu.generate)), "eye",             Color("StickerBlue"),    HomeDestination.stickerConfig),
            (String(localized: String.LocalizationValue(L10n.Home.Menu.hints)),    "lightbulb.fill",  Color("HintsYellow"),    HomeDestination.hints),
            (String(localized: String.LocalizationValue(L10n.Home.Menu.settings)), "gearshape.fill",  Color("SettingsPurple"), HomeDestination.settings)
        ]
    }
}
