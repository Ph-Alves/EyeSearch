//
//  HomeViewUITest.swift
//  EyeSearchUITests
//
//  Created by Daniela Valadares on 25/04/26.
//

import XCTest

final class HomeViewUITest: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        // Pula o onboarding para ir direto à HomeView
        app.launchArguments += ["-hasCompletedOnboarding", "true"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testHomeView_exhibitionEyeSearchTitle() {
        // Arrange
        // App iniciado com onboarding concluído (setUp)

        // Act
        // Nenhuma ação necessária

        // Assert
        XCTAssertTrue(app.navigationBars["EyeSearch"].waitForExistence(timeout: 5),
                      "A HomeView deve exibir o título 'EyeSearch' na navigation bar")
    }

    func testHomeView_exhibitionNavegationCards() {
        // Arrange
        XCTAssertTrue(app.navigationBars["EyeSearch"].waitForExistence(timeout: 5))

        // Act
        // Nenhuma ação necessária

        // Assert
        // Deve haver todos os cards na tela
        XCTAssertTrue(app.buttons.count == 4,
                      "A HomeView deve exibir ao menos um card de navegação")
    }

    func testHomeView_navegationForHintsView() {
        // Arrange
        XCTAssertTrue(app.navigationBars["EyeSearch"].waitForExistence(timeout: 5))
        let cardDicas = app.buttons["Dicas"]
        XCTAssertTrue(cardDicas.waitForExistence(timeout: 3))

        // Act
        cardDicas.tap()

        // Assert
        XCTAssertTrue(app.staticTexts["Dicas"].waitForExistence(timeout: 5),
                      "Tocar no card 'Dicas' deve navegar para a HintsView")
    }

    func testHomeView_navegationForStickerView() {
        // Arrange
        XCTAssertTrue(app.navigationBars["EyeSearch"].waitForExistence(timeout: 5))
        let cardAdesivos = app.buttons["Gerar"]
        XCTAssertTrue(cardAdesivos.waitForExistence(timeout: 6))

        // Act
        cardAdesivos.tap()

        // Assert
        XCTAssertTrue(app.staticTexts["Imprimir Adesivo"].waitForExistence(timeout: 5),
                      "Tocar no card 'Imprimir Adesivo' deve navegar para a StickerView")
    }

    func testHomeView_navegationForSearchView() {
        // Arrange
        XCTAssertTrue(app.navigationBars["EyeSearch"].waitForExistence(timeout: 5))
        let cardBuscar = app.buttons["Procurar"]
        XCTAssertTrue(cardBuscar.waitForExistence(timeout: 6))

        // Act
        cardBuscar.tap()

        // Assert
        // SearchObjectView exibe texto de status da câmera
        let procurando = app.staticTexts["Procurando..."]
        let encontrados = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'adesivos encontrados'")).firstMatch
        XCTAssertTrue(procurando.waitForExistence(timeout: 5) || encontrados.waitForExistence(timeout: 5),
                      "Tocar em 'Buscar Adesivos' deve navegar para a SearchObjectView")
    }

    func testHomeView_scrollHomeView() {
        // Arrange
        XCTAssertTrue(app.navigationBars["EyeSearch"].waitForExistence(timeout: 5))
        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(scrollView.waitForExistence(timeout: 3))

        // Act
        scrollView.swipeUp()

        // Assert
        // Após o scroll, a scroll view ainda deve existir (não crashou)
        XCTAssertTrue(app.scrollViews.firstMatch.exists,
                      "A HomeView deve suportar scroll sem falhas")
    }
}
