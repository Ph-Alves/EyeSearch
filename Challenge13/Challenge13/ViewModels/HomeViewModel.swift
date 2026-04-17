//
//  HomeViewModel.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 17/04/26.
//

import Foundation
import SwiftUI

@Observable
class HomeViewModel {
    // MARK: - Init
    init() {}
    
    // MARK: - Functions
    func generateItems() -> [(title: String, icon: String, color: Color, screen: HomeDestination)] {
        return [
            ("Procurar",     "magnifyingglass", Color("SearchGreen"),    HomeDestination.searchObject),
            ("Gerar",        "eye",             Color("StickerBlue"),    HomeDestination.stickerConfig),
            ("Dicas",        "lightbulb.fill",  Color("HintsYellow"),    HomeDestination.hints),
            ("Configurações", "gearshape.fill", Color("SettingsPurple"), HomeDestination.settings)
        ]
    }
}
