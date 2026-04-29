//
//  SettingsManagerTests.swift
//  EyeSearchTests
//
//  Created by Manoel Pedro Prado Sa Teles on 22/04/26.
//

import XCTest
@testable import EyeSearch

// MARK: - Test Suite

final class SettingsManagerTests: XCTestCase {

    // MARK: Débitos
    //
    // UserDefaults.standard hardcoded — não é FIRST-compliant ideal.
    // setUp/tearDown limpam as chaves para garantir isolamento entre testes,
    // mas uma falha no meio pode deixar estado sujo em outros contextos.
    // Proposta: adicionar init(userDefaults: UserDefaults) ao SettingsManager
    // e injetar UserDefaults(suiteName: "com.test.settings") nos testes.

    // MARK: - Chaves (espelham o enum Keys privado do SettingsManager)

    private let hapticsKey = "isHapticsEnabled"
    private let soundKey   = "isSoundEnabled"

    // MARK: - Propriedades

    private var sut: SettingsManaging!

    // MARK: - Setup / Teardown

    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: hapticsKey)
        UserDefaults.standard.removeObject(forKey: soundKey)
        sut = SettingsManager.shared
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: hapticsKey)
        UserDefaults.standard.removeObject(forKey: soundKey)
        sut = nil
        super.tearDown()
    }

    // MARK: - Additional coverage

    func test_Load_WithNoSavedValues_ReturnsDefaultsTrue() {
        // Arrange — setUp já removeu as chaves do UserDefaults

        // Act
        let settings = sut.load()

        // Assert
        XCTAssertTrue(settings.isHapticsEnabled, "isHapticsEnabled deve ser true por padrão quando não há valor salvo.")
        XCTAssertTrue(settings.isSoundEnabled,   "isSoundEnabled deve ser true por padrão quando não há valor salvo.")
    }

    func test_Save_Then_Load_ReturnsPersistedValues() {
        // Arrange
        let toSave = UserSettings(isHapticsEnabled: false, isSoundEnabled: false)

        // Act
        sut.save(toSave)
        let loaded = sut.load()

        // Assert
        XCTAssertFalse(loaded.isHapticsEnabled, "isHapticsEnabled deve ser false após salvar false.")
        XCTAssertFalse(loaded.isSoundEnabled,   "isSoundEnabled deve ser false após salvar false.")
    }

    func test_Save_WithHapticsDisabled_PersistsFalse() {
        // Arrange
        let settings = UserSettings(isHapticsEnabled: false, isSoundEnabled: true)

        // Act
        sut.save(settings)
        let loaded = sut.load()

        // Assert
        XCTAssertFalse(loaded.isHapticsEnabled, "isHapticsEnabled deve persistir false.")
        XCTAssertTrue(loaded.isSoundEnabled,    "isSoundEnabled não deve ser alterado.")
    }

    func test_Save_WithSoundDisabled_PersistsFalse() {
        // Arrange
        let settings = UserSettings(isHapticsEnabled: true, isSoundEnabled: false)

        // Act
        sut.save(settings)
        let loaded = sut.load()

        // Assert
        XCTAssertTrue(loaded.isHapticsEnabled,  "isHapticsEnabled não deve ser alterado.")
        XCTAssertFalse(loaded.isSoundEnabled,   "isSoundEnabled deve persistir false.")
    }
}
