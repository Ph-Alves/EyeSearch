//
//  SettingsViewModel.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 14/04/26.
//
import Foundation

// MARK: - ViewModel
/// # ViewModel - SettingsViewModel
/// ViewModel da tela de configurações do app.
/// Gerencia as preferências de haptics e som, persistindo via `SettingsManager`.
/// ## Usado em:
/// - ``SettingsView``
@Observable
@MainActor
class SettingsViewModel {
    // MARK: - Variables
    /// Manager de feedback tátil (injetado via protocolo).
    private let haptics: HapticsManaging
    /// Manager de reprodução de som (injetado via protocolo).
    private let soundManager: SoundManaging
    /// Manager de persistência de configurações (injetado via protocolo).
    private let settingsManager: SettingsManaging
    
    /// Configurações atuais do usuário.
    private(set) var settings: UserSettings
    
    // MARK: - Init
    /// Inicializa com os managers injetados e carrega as configurações do UserDefaults.
    /// - Parameters:
    ///   - haptics: Manager de haptics.
    ///   - soundManager: Manager de som.
    ///   - settingsManager: Manager de persistência.
    init(haptics: HapticsManaging, soundManager: SoundManaging, settingsManager: SettingsManager) {
        self.haptics = haptics
        self.settingsManager = settingsManager
        self.soundManager = soundManager
        
        // Carrega as configurações salvas do UserDefaults
        self.settings = settingsManager.load()
    }
    
    
    // MARK: - Haptics
    /// Alterna o estado dos haptics e persiste a mudança.
    /// - Parameter enabled: `true` para habilitar, `false` para desabilitar.
    func toggleHaptics(_ enabled: Bool) {
        settings.isHapticsEnabled = enabled
        settingsManager.save(settings)
    }
    
    /// Dispara o feedback tátil se estiver habilitado nas configurações.
    func triggerHaptic() {
        haptics.trigger(isEnabled: settings.isHapticsEnabled)
    }
    
    
    // MARK: - Sound
    /// Alterna o estado do som e persiste a mudança.
    /// - Parameter enabled: `true` para habilitar, `false` para desabilitar.
    func toggleSound(_ enabled: Bool) {
        settings.isSoundEnabled = enabled
        settingsManager.save(settings)
    }
    
    /// Reproduz o som de feedback se estiver habilitado nas configurações.
    func playSound() {
        soundManager.playSound(isEnabled: settings.isSoundEnabled)
    }
        
        
    /// Restaura todas as configurações para os valores padrão (tudo habilitado).
    func resetConfiguration() {
        settings = UserSettings(
            isHapticsEnabled: true,
            isSoundEnabled: true
        )
        
        settingsManager.save(settings)
        
        soundManager.reset()
        haptics.reset()
    }
}
