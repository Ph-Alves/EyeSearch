//
//  DependencyContainer.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 16/04/26.
//

import Foundation

// MARK: - DependencyContainer
/// # DependencyContainer
/// Container de injeção de dependências que armazena as ViewModels do app.
/// Usa `lazy var` para instanciar cada ViewModel apenas quando for acessada pela primeira vez,
/// garantindo instância única durante toda a navegação.
/// ## Usado em:
/// - ``Coordinator``
class DependencyContainer {
    /// ViewModel da tela principal.
    lazy var homeViewModel = HomeViewModel()
    /// ViewModel da tela de busca de objetos.
    lazy var searchViewModel = SearchObjectViewModel(camera: CameraManager(), sound: SoundManager(), haptics: HapticsManager(), mlManager: MLModelManager.shared, settingsManager: SettingsManager())
    /// ViewModel da tela de geração de adesivos.
    lazy var stickerViewModel = StickerViewModel(pdfManager: PDFManager())
    /// Manager do chat (compartilhado para manter estado da sessão).
    lazy var foundationsManager = FoundationsManager()
    /// ViewModel da tela de configurações.
    lazy var settingsViewModel = SettingsViewModel(haptics: HapticsManager(), soundManager: SoundManager(), settingsManager: SettingsManager())
}
