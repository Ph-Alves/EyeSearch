//
//  SettingsViewModelTests.swift
//  EyeSearchTests
//
//  Created by Manoel Pedro Prado Sa Teles on 24/04/26.
//

import XCTest
@testable import EyeSearch

// MARK: Débitos
//
// Interações com SettingsManaging via spy (test_Init_LoadsSettingsFromManager, etc.):
//   SettingsViewModel.init recebe SettingsManager concreto em vez de SettingsManaging.
//   Sem refatoração do parâmetro do init de produção, não é possível injetar um spy
//   de SettingsManaging e verificar isoladamente as chamadas de save/load.
//   Workaround atual: instância real de SettingsManager com limpeza de UserDefaults.

// MARK: - Test Suite

@MainActor
final class SettingsViewModelTests: XCTestCase {

    // MARK: - Chaves (espelham o enum Keys privado do SettingsManager)

    private let hapticsKey = "isHapticsEnabled"
    private let soundKey   = "isSoundEnabled"

    // MARK: - Propriedades

    private var sut: SettingsViewModel!
    private var verifyManager: SettingsManaging!

    // MARK: - Setup / Teardown

    override func setUp() async throws {
        UserDefaults.standard.removeObject(forKey: hapticsKey)
        UserDefaults.standard.removeObject(forKey: soundKey)
        sut = SettingsViewModel(
            haptics: HapticsManager.shared,
            soundManager: SoundManager.shared,
            settingsManager: SettingsManager.shared
        )
        verifyManager = SettingsManager.shared
    }

    override func tearDown() async throws {
        UserDefaults.standard.removeObject(forKey: hapticsKey)
        UserDefaults.standard.removeObject(forKey: soundKey)
        sut = nil
        verifyManager = nil
    }

    // MARK: - Init

    func test_Init_LoadsDefaultSettings() {
        // Arrange / Act — init executado no setUp com UserDefaults limpo

        // Assert
        XCTAssertNotNil(sut, "SettingsViewModel deve ser inicializado sem crash.")
        XCTAssertTrue(sut.settings.isHapticsEnabled, "isHapticsEnabled deve ser true por padrão.")
        XCTAssertTrue(sut.settings.isSoundEnabled,   "isSoundEnabled deve ser true por padrão.")
    }

    // MARK: - toggleHaptics

    func test_ToggleHaptics_ToFalse_UpdatesState() {
        // Arrange — defaults: isHapticsEnabled = true

        // Act
        sut.toggleHaptics(false)

        // Assert
        XCTAssertFalse(sut.settings.isHapticsEnabled, "toggleHaptics(false) deve atualizar settings.isHapticsEnabled.")
    }

    func test_ToggleHaptics_ToFalse_PersistsToUserDefaults() {
        // Arrange

        // Act
        sut.toggleHaptics(false)

        // Assert — nova instância de SettingsManager lê o valor persistido
        let loaded = verifyManager.load()
        XCTAssertFalse(loaded.isHapticsEnabled, "toggleHaptics(false) deve persistir via SettingsManager.")
    }

    func test_ToggleHaptics_ToTrue_AfterFalse_RestoresState() {
        // Arrange — desabilita primeiro
        sut.toggleHaptics(false)
        XCTAssertFalse(sut.settings.isHapticsEnabled, "Pré-condição: haptics deve estar desabilitado.")

        // Act
        sut.toggleHaptics(true)

        // Assert
        XCTAssertTrue(sut.settings.isHapticsEnabled, "toggleHaptics(true) deve restaurar isHapticsEnabled.")
    }

    // MARK: - toggleSound

    func test_ToggleSound_ToFalse_UpdatesState() {
        // Arrange

        // Act
        sut.toggleSound(false)

        // Assert
        XCTAssertFalse(sut.settings.isSoundEnabled, "toggleSound(false) deve atualizar settings.isSoundEnabled.")
    }

    func test_ToggleSound_ToFalse_PersistsToUserDefaults() {
        // Arrange

        // Act
        sut.toggleSound(false)

        // Assert
        let loaded = verifyManager.load()
        XCTAssertFalse(loaded.isSoundEnabled, "toggleSound(false) deve persistir via SettingsManager.")
    }

    // MARK: - T27 — RN28 — triggerHaptic

    func test_TriggerHaptic_WhenEnabled_DoesNotCrash() {
        // Arrange — haptics habilitado por padrão

        // Act & Assert
        XCTAssertNoThrow(sut.triggerHaptic(), "triggerHaptic com haptics habilitado não deve crashar.")
    }

    func test_TriggerHaptic_WhenDisabled_DoesNotCrash() {
        // Arrange — guard isEnabled no HapticsManager.trigger deve retornar cedo
        sut.toggleHaptics(false)

        // Act & Assert
        XCTAssertNoThrow(sut.triggerHaptic(), "triggerHaptic com haptics desabilitado não deve crashar.")
    }

    // MARK: - T28 — RN28 — playSound

    func test_PlaySound_WhenEnabled_DoesNotCrash() {
        // Arrange — som habilitado por padrão

        // Act & Assert
        XCTAssertNoThrow(sut.playSound(), "playSound com som habilitado não deve crashar.")
    }

    func test_PlaySound_WhenDisabled_DoesNotCrash() {
        // Arrange — guard isEnabled no SoundManager.playSound deve retornar cedo
        sut.toggleSound(false)

        // Act & Assert
        XCTAssertNoThrow(sut.playSound(), "playSound com som desabilitado não deve crashar.")
    }

    // MARK: - resetConfiguration

    func test_ResetConfiguration_RestoresBothDefaults() {
        // Arrange — altera ambas as configurações para false
        sut.toggleHaptics(false)
        sut.toggleSound(false)
        XCTAssertFalse(sut.settings.isHapticsEnabled, "Pré-condição: haptics deve estar desabilitado.")
        XCTAssertFalse(sut.settings.isSoundEnabled,   "Pré-condição: som deve estar desabilitado.")

        // Act
        sut.resetConfiguration()

        // Assert
        XCTAssertTrue(sut.settings.isHapticsEnabled, "Após reset, isHapticsEnabled deve ser true.")
        XCTAssertTrue(sut.settings.isSoundEnabled,   "Após reset, isSoundEnabled deve ser true.")
    }

    func test_ResetConfiguration_PersistsDefaultsToUserDefaults() {
        // Arrange — persiste false para ambas as chaves
        sut.toggleHaptics(false)
        sut.toggleSound(false)

        // Act
        sut.resetConfiguration()

        // Assert — verifica que UserDefaults foi sobrescrito com os defaults
        let loaded = verifyManager.load()
        XCTAssertTrue(loaded.isHapticsEnabled, "resetConfiguration deve persistir isHapticsEnabled=true.")
        XCTAssertTrue(loaded.isSoundEnabled,   "resetConfiguration deve persistir isSoundEnabled=true.")
    }

    func test_ResetConfiguration_DoesNotCrash() {
        // Arrange — estado padrão (tudo habilitado)

        // Act & Assert — cobre o fluxo completo: settingsManager.save + soundManager.reset + haptics.reset
        XCTAssertNoThrow(sut.resetConfiguration(), "resetConfiguration não deve crashar no estado padrão.")
    }
}
