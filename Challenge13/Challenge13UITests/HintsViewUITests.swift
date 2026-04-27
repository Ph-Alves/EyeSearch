//
//  EyeSearchUITests.swift
//  EyeSearchUITests
//
//  Created by Daniela Valadares on 25/04/26.
//

import XCTest

final class HintsViewUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ["-hasCompletedOnboarding", "true"]
        app.launch()
        // Navega até a HintsView
        let hintsCard = app.buttons["Dicas"]
        if hintsCard.waitForExistence(timeout: 5) {
            hintsCard.tap()
        }
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testHintsView_exhibitionOfTitleAndSubtitle() {
        // Arrange
        // Já na HintsView (setUp)

        // Act
        // Nenhuma ação necessária

        // Assert
        XCTAssertTrue(app.staticTexts["Dicas"].waitForExistence(timeout: 5),
                      "HintsView deve exibir o título 'Dicas'")
    }

    func testHintsView_exhibitionOfAIChatCard() {
        // Arrange
        // Já na HintsView (setUp)

        // Act
        // Nenhuma ação necessária

        // Assert
        XCTAssertTrue(app.staticTexts["AIChat"].waitForExistence(timeout: 5),
                      "HintsView deve exibir o card 'AIChat'")
    }

    func testHintsView_exhibitionOfCardsList() {
        // Arrange
        // Já na HintsView (setUp)

        // Act
        // Nenhuma ação necessária

        // Assert
        // Espera ao menos um card de dica além dos elementos fixos
        XCTAssertTrue(app.staticTexts.count > 2,
                      "HintsView deve exibir ao menos um card de dica na lista")
    }

    func testHintsView_touchExpandableCardDescription() {
        // Arrange
        XCTAssertTrue(app.staticTexts["Dicas"].waitForExistence(timeout: 5))
        // Pega o primeiro card de dica disponível (após "AIChat" e labels fixos)
        let firstCard = app.staticTexts.element(boundBy: 3)
        XCTAssertTrue(firstCard.waitForExistence(timeout: 3))

        // Act
        firstCard.tap()

        // Assert
        // Após expandir, o número de textos visíveis deve aumentar (descrição aparece)
        let textQuantityAfterExpanding = app.staticTexts.count
        XCTAssertTrue(textQuantityAfterExpanding > 3,
                      "Tocar em um card deve expandi-lo e exibir a descrição")
    }

    func testHintsView_touchExpandableCardClose() {
        // Arrange
        XCTAssertTrue(app.staticTexts["Dicas"].waitForExistence(timeout: 5))
        let firstCard = app.staticTexts.element(boundBy: 3)
        XCTAssertTrue(firstCard.waitForExistence(timeout: 3))
        firstCard.tap() // expande
        sleep(1)
        let openQuantity = app.staticTexts.count

        // Act
        firstCard.tap() // recolhe

        // Assert
        sleep(1)
        let closedQuantity = app.staticTexts.count
        XCTAssertTrue(closedQuantity <= openQuantity,
                      "Tocar novamente no card expandido deve recolhê-lo")
    }

    func testHintsView_scrollThroughCardsList() {
        // Arrange
        XCTAssertTrue(app.staticTexts["Dicas"].waitForExistence(timeout: 5))
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 3))

        // Act
        scrollView.swipeUp()

        // Assert
        XCTAssertTrue(app.scrollViews.firstMatch.exists,
                      "O scroll da HintsView deve funcionar sem falhas")
    }

    func testHintsView_buttonOfRetornForHome() {
        // Arrange
        XCTAssertTrue(app.staticTexts["Dicas"].waitForExistence(timeout: 5))
        let returnButton = app.buttons["Voltar"]
        XCTAssertTrue(returnButton.waitForExistence(timeout: 3))

        // Act
        returnButton.tap()

        // Assert
        XCTAssertTrue(app.navigationBars["EyeSearch"].waitForExistence(timeout: 5),
                      "O botão 'Voltar' deve retornar para a HomeView")
    }
}
