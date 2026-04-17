//
//  DependencyContainer.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 16/04/26.
//

import Foundation

class DependencyContainer {
    lazy var homeViewModel = HomeViewModel()
    lazy var searchViewModel = SearchObjectViewModel()
    lazy var stickerViewModel = StickerViewModel()
    lazy var settingsViewModel = SettingsViewModel(haptics: HapticsManager(), soundManager: SoundManager.manager)
}
