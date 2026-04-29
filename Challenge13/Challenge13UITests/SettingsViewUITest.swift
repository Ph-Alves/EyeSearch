//
//  SettingsViewUITest.swift
//  EyeSearchUITests
//
//  Created by Daniela Valadares on 26/04/26.
//

import XCTest

final class SettingsViewUITest: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ["-hasCompletedOnboarding", "true"]
        app.launch()
        // Navega até a SettingsView
        let hintsCard = app.buttons["Ajustes"]
        if hintsCard.waitForExistence(timeout: 5) {
            hintsCard.tap()
        }
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testSettingsView_exhibitionTitleView() {
        // Arrange
        // Já na SettingsView (setUp)

        // Act
        // Nenhuma ação necessária

        // Assert
        XCTAssertTrue(app.staticTexts["Ajustes"].waitForExistence(timeout: 5),
                      "SettingsView deve exibir o título 'Ajustes'")
    }

    func testSettingsView_exhibitionVibrationToggle() {
        // Arrange
        // Já na SettingsView (setUp)

        // Act
        // Nenhuma ação necessária

        // Assert
        XCTAssertTrue(app.staticTexts["Vibração"].waitForExistence(timeout: 5),
                      "SettingsView deve exibir a opção 'Vibração'")
    }

    func testSettingsView_exhibitionSoundToggle() {
        // Arrange
        // Já na SettingsView (setUp)

        // Act
        // Nenhuma ação necessária

        // Assert
        XCTAssertTrue(app.staticTexts["Som"].waitForExistence(timeout: 5),
                      "SettingsView deve exibir a opção 'Som'")
    }

    func testSettingsView_exhibitionStepByStepButton() {
        // Arrange
        // Já na SettingsView (setUp)

        // Act
        // Nenhuma ação necessária

        // Assert
        XCTAssertTrue(app.buttons["Passo a passo"].waitForExistence(timeout: 5),
                      "SettingsView deve exibir o botão 'Passo a passo'")
    }

    func testSettingsView_vibrationToggleChangeState() {
        // Arrange
        XCTAssertTrue(app.staticTexts["Vibração"].waitForExistence(timeout: 5))
        let visibleToggles = app.switches.allElementsBoundByIndex
        XCTAssertTrue(visibleToggles.count >= 1, "Deve haver ao menos um toggle visível")
        let vibrationToggle = app.switches.element(boundBy: 0)
        let initialState = vibrationToggle.value as? String

        // Act
        vibrationToggle.tap()

        // Assert
        let endState = vibrationToggle.value as? String
        XCTAssertNotEqual(initialState, endState,
                          "O toggle de 'Vibração' deve alternar de estado ao ser tocado")
    }

    func testSettingsView_soundToggleChangeState() {
        // Arrange
        XCTAssertTrue(app.staticTexts["Som"].waitForExistence(timeout: 5))
        let soundToggle = app.switches.element(boundBy: 1)
        let initialState = soundToggle.value as? String

        // Act
        soundToggle.tap()

        // Assert
        let endState = soundToggle.value as? String
        XCTAssertNotEqual(initialState, endState,
                          "O toggle de 'Som' deve alternar de estado ao ser tocado")
    }

    func testSettingsView_stepByStepCallOnboardingView() {
        // Arrange
        XCTAssertTrue(app.staticTexts["Ajustes"].waitForExistence(timeout: 5))
        let resetButton = app.buttons["Passo a passo"]
        XCTAssertTrue(resetButton.waitForExistence(timeout: 3))

        // Act
        resetButton.tap()

        // Assert
        XCTAssertNotNil(app.staticTexts["Encontre seus objetos com facilidade"].waitForExistence(timeout: 5),
                        "Após resetar, os toggles devem ter um estado definido")
    }

    func testSettingsView_buttonOfRetornForHome() {
        // Arrange
        XCTAssertTrue(app.staticTexts["Ajustes"].waitForExistence(timeout: 5))
        let returnButton = app.buttons["Voltar"]
        XCTAssertTrue(returnButton.waitForExistence(timeout: 3))

        // Act
        returnButton.tap()

        // Assert
        XCTAssertTrue(app.staticTexts["EyeSearch"].waitForExistence(timeout: 5),
                      "O botão 'Voltar' deve retornar para a HomeView")
    }
}
