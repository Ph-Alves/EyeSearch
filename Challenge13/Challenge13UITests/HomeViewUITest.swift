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
        XCTAssertTrue(app.staticTexts["EyeSearch"].waitForExistence(timeout: 5),
                      "A HomeView deve exibir o título 'EyeSearch' na navigation bar")
    }

    func testHomeView_exhibitionNavegationCards() {
        // Arrange
        XCTAssertTrue(app.staticTexts["EyeSearch"].waitForExistence(timeout: 5))

        // Act
        // Nenhuma ação necessária

        // Assert
        // Deve haver todos os cards na tela
        XCTAssertTrue(app.buttons.count == 4,
                      "A HomeView deve exibir ao menos um card de navegação")
    }

    func testHomeView_navegationForHintsView() {
        // Arrange
        XCTAssertTrue(app.staticTexts["EyeSearch"].waitForExistence(timeout: 5))
        let hintsCard = app.buttons["Dicas"]
        XCTAssertTrue(hintsCard.waitForExistence(timeout: 3))

        // Act
        hintsCard.tap()

        // Assert
        XCTAssertTrue(app.staticTexts["Dicas"].waitForExistence(timeout: 5),
                      "Tocar no card 'Dicas' deve navegar para a HintsView")
    }

    func testHomeView_navegationForStickerView() {
        // Arrange
        XCTAssertTrue(app.staticTexts["EyeSearch"].waitForExistence(timeout: 5))
        let stickersCard = app.buttons["Adesivos"]
        XCTAssertTrue(stickersCard.waitForExistence(timeout: 6))

        // Act
        stickersCard.tap()

        // Assert
        XCTAssertTrue(app.staticTexts["Imprimir Adesivo"].waitForExistence(timeout: 5),
                      "Tocar no card 'Imprimir Adesivo' deve navegar para a StickerView")
    }

    func testHomeView_navegationForSearchView() {
        // Arrange
        XCTAssertTrue(app.staticTexts["EyeSearch"].waitForExistence(timeout: 5))
        let searchCard = app.buttons["Procurar"]
        XCTAssertTrue(searchCard.waitForExistence(timeout: 6))

        // Act
        searchCard.tap()

        // Assert
        // SearchObjectView exibe texto de status da câmera
        let searching = app.staticTexts["Procurando adesivo..."]
        let found = app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'adesivos encontrados'")).firstMatch
        XCTAssertTrue(searching.waitForExistence(timeout: 5) || found.waitForExistence(timeout: 5),
                      "Tocar em 'Buscar Adesivos' deve navegar para a SearchObjectView")
    }

//    func testHomeView_scrollHomeView() {
//        // Arrange
//        XCTAssertTrue(app.staticTexts["EyeSearch"].waitForExistence(timeout: 5))
//        let scrollView = app.scrollViews.firstMatch
//        XCTAssertTrue(scrollView.waitForExistence(timeout: 3))
//
//        // Act
//        scrollView.swipeUp()
//
//        // Assert
//        // Após o scroll, a scroll view ainda deve existir (não crashou)
//        XCTAssertTrue(app.scrollViews.firstMatch.exists,
//                      "A HomeView deve suportar scroll sem falhas")
//    }
}
