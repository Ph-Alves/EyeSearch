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
    func generateItems() -> [(title: String, icon: String, color: Color, borderColor: Color, screen: HomeDestination)] {
        return [

            ("Procurar",     "eye.fill", Color("searchPrimary"), Color("SearchPrimaryBorder"), HomeDestination.searchObject),
            ("Adesivos",        "printer.fill",             Color("stickerPrimary"), Color("StickerPrimaryBorder"),   HomeDestination.stickerConfig),
            ("Dicas",        "lightbulb.fill",  Color("hintsPrimary"),  Color("HintsPrimaryBorder"),  HomeDestination.hints),
            ("Ajustes", "gearshape.fill", Color("settingsPrimary"), Color("settingsPrimaryBorder"), HomeDestination.settings)
        ]
    }
}

