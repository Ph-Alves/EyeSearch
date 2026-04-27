//
//  SearchObjectViewUITest.swift
//  EyeSearchUITests
//
//  Created by Daniela Valadares on 26/04/26.
//

import XCTest

final class SearchObjectViewUITest: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ["-hasCompletedOnboarding", "true"]
        // Concede permissão de câmera automaticamente em testes
        app.launchArguments += ["-grantCameraPermission", "true"]
        app.launch()
        // Navega até a SearchObjectView
        let searchCard = app.buttons["Procurar"]
        if searchCard.waitForExistence(timeout: 5) {
            searchCard.tap()
        }
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testSearchObjectView_exhibitionSearchingMenssage() {
        // Arrange
        // Já na SearchObjectView sem adesivos detectados (setUp)

        // Act
        // Nenhuma ação necessária

        // Assert
        XCTAssertTrue(
            app.staticTexts["Procurando..."].waitForExistence(timeout: 5),
            "SearchObjectView deve exibir 'Procurando...' quando nenhum adesivo é detectado"
        )
    }
    
    func testSearchObjectView_flashlightButtonSwitchIcon() {
        // Arrange
        let onButton = app.buttons["Lanterna ligada"]
        XCTAssertTrue(onButton.waitForExistence(timeout: 5))

        // Act
        onButton.tap()

        // Assert
        XCTAssertTrue(app.buttons["Lanterna desligada"].waitForExistence(timeout: 3),
                      "Após tocar, o botão deve indicar que a lanterna está desligada")
    }

    func testSearchObjectView_waveOverlayMissingWhenNoStickerIsFound() {
        // Arrange
        // Já na SearchObjectView sem detecções (setUp)

        // Act
        // Nenhuma ação necessária

        // Assert
        // A WaveOverlay usa elementos de desenho (RoundedRectangle) — sem detecções,
        // a view não deve conter o overlay animado ativo.
        // Verifica indiretamente: o status "Procurando..." deve ser o único label de status.
        XCTAssertTrue(
            app.staticTexts["Procurando..."].waitForExistence(timeout: 5),
            "Sem adesivos detectados, apenas 'Procurando...' deve aparecer como status"
        )
        XCTAssertFalse(
            app.staticTexts.containing(NSPredicate(format: "label CONTAINS 'adesivos encontrados'"))
                .firstMatch.exists,
            "WaveOverlay e contagem não devem aparecer sem detecções"
        )
    }

    func testSearchObjectView_buttonOfRetornForHome() {
        // Arrange
        XCTAssertTrue(app.staticTexts["Procurando..."].waitForExistence(timeout: 5))
        let returnButton = app.buttons["Voltar"]
        XCTAssertTrue(returnButton.waitForExistence(timeout: 3))

        
        // Act
        returnButton.tap()

        // Assert
        XCTAssertTrue(
            app.navigationBars["EyeSearch"].waitForExistence(timeout: 5),
            "Sair da SearchObjectView deve retornar para a HomeView e parar a câmera"
        )
    }
}
