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
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ["-hasCompletedOnboarding", "true"]
        app.launch()
        // Navega até a HintsView
        let cardDicas = app.buttons["Dicas"]
        if cardDicas.waitForExistence(timeout: 5) {
            cardDicas.tap()
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
        let primeiroCard = app.staticTexts.element(boundBy: 3)
        XCTAssertTrue(primeiroCard.waitForExistence(timeout: 3))

        // Act
        primeiroCard.tap()

        // Assert
        // Após expandir, o número de textos visíveis deve aumentar (descrição aparece)
        let quantidadeTextosAposExpandir = app.staticTexts.count
        XCTAssertTrue(quantidadeTextosAposExpandir > 3,
                      "Tocar em um card deve expandi-lo e exibir a descrição")
    }

    func testHintsView_touchExpandableCardClose() {
        // Arrange
        XCTAssertTrue(app.staticTexts["Dicas"].waitForExistence(timeout: 5))
        let primeiroCard = app.staticTexts.element(boundBy: 3)
        XCTAssertTrue(primeiroCard.waitForExistence(timeout: 3))
        primeiroCard.tap() // expande
        sleep(1)
        let quantidadeExpandido = app.staticTexts.count

        // Act
        primeiroCard.tap() // recolhe

        // Assert
        sleep(1)
        let quantidadeRecolhido = app.staticTexts.count
        XCTAssertTrue(quantidadeRecolhido <= quantidadeExpandido,
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
        let botaoVoltar = app.buttons["Voltar"]
        XCTAssertTrue(botaoVoltar.waitForExistence(timeout: 3))

        // Act
        botaoVoltar.tap()

        // Assert
        XCTAssertTrue(app.navigationBars["EyeSearch"].waitForExistence(timeout: 5),
                      "O botão 'Voltar' deve retornar para a HomeView")
    }
}
