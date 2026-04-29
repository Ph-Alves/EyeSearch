//
//  StickerViewUITest.swift
//  EyeSearchUITests
//
//  Created by Daniela Valadares on 25/04/26.
//

import XCTest

final class StickerViewUITest: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments += ["-hasCompletedOnboarding", "true"]
        app.launch()
        // Navega até a StickerView
        let stickerCard = app.buttons["Adesivos"]
        if stickerCard.waitForExistence(timeout: 5) {
            stickerCard.tap()
        }
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testStickerView_exhibitionTitleView() {
        // Arrange
        // Já na StickerView (setUp)

        // Act
        // Nenhuma ação necessária

        // Assert
        XCTAssertTrue(app.staticTexts["Imprimir Adesivo"].waitForExistence(timeout: 5),
                      "StickerView deve exibir o título 'Imprimir Adesivo'")
    }

    func testStickerView_exhibitionStepperWithInitialValueOne() {
        // Arrange
        // Já na StickerView (setUp)

        // Act
        // Nenhuma ação necessária

        // Assert
        XCTAssertTrue(app.staticTexts["1"].waitForExistence(timeout: 5),
                      "O stepper deve iniciar com quantidade 1")
    }

    func testStickerView_exhibitionInfoCardA4() {
        // Arrange
        // Já na StickerView (setUp)

        // Act
        // Nenhuma ação necessária

        // Assert
        // Com quantity=1, o texto esperado é "1 adesivo - 1 Folhas A4"
        XCTAssertTrue(
            app.staticTexts["1 adesivo - 1 Folhas A4"].waitForExistence(timeout: 5),
            "O card A4 deve exibir '1 adesivo - 1 Folhas A4' como valor inicial"
        )
    }

    func testStickerView_exhibitionButtonToGeneratePDF() {
        // Arrange
        // Já na StickerView (setUp)

        // Act
        // Nenhuma ação necessária

        // Assert
        XCTAssertTrue(app.buttons["Gerar PDF"].waitForExistence(timeout: 5),
                      "StickerView deve exibir o botão 'Gerar PDF'")
    }

    func testStickerView_buttonPlusIncreaseQuantity() {
        // Arrange
        XCTAssertTrue(app.staticTexts["1"].waitForExistence(timeout: 5))
        let plusButton = app.buttons["+"]
        XCTAssertTrue(plusButton.waitForExistence(timeout: 3))

        // Act
        plusButton.tap()

        // Assert
        XCTAssertTrue(app.staticTexts["2"].waitForExistence(timeout: 3),
                      "Tocar '+' deve incrementar a quantidade para 2")
    }

    func testStickerView_buttonMinusDecreaseQuantity() {
        // Arrange
        XCTAssertTrue(app.staticTexts["1"].waitForExistence(timeout: 5))
        let plusButton = app.buttons["+"]
        XCTAssertTrue(plusButton.waitForExistence(timeout: 3))
        plusButton.tap() // vai para 2
        XCTAssertTrue(app.staticTexts["2"].waitForExistence(timeout: 3))
        let minusButton = app.buttons["−"]
        XCTAssertTrue(minusButton.waitForExistence(timeout: 3))

        // Act
        minusButton.tap()

        // Assert
        XCTAssertTrue(app.staticTexts["1"].waitForExistence(timeout: 3),
                      "Tocar '−' deve decrementar a quantidade de volta para 1")
    }

    func testStickerView_smallestQuantityIsOne() {
        // Arrange
        XCTAssertTrue(app.staticTexts["1"].waitForExistence(timeout: 5))
        let minusButton = app.buttons["−"]
        XCTAssertTrue(minusButton.waitForExistence(timeout: 3))

        // Act
        minusButton.tap() // tenta decrementar abaixo de 1

        // Assert
        XCTAssertTrue(app.staticTexts["1"].waitForExistence(timeout: 3),
                      "A quantidade não deve ser menor que 1")
    }

    func testStickerView_infoCardA4UpdateWhenIncrementing() {
        // Arrange
        XCTAssertTrue(app.staticTexts["1 adesivo - 1 Folhas A4"].waitForExistence(timeout: 5))
        let plusButton = app.buttons["+"]
        XCTAssertTrue(plusButton.waitForExistence(timeout: 3))

        // Act — incrementa até 25 (ultrapassa os 24 por folha)
        for _ in 0..<24 {
            plusButton.tap()
        }

        // Assert
        // 25 adesivos precisam de 2 folhas A4
        XCTAssertTrue(
            app.staticTexts["25 adesivos - 2 Folhas A4"].waitForExistence(timeout: 5),
            "Com 25 adesivos, o card deve mostrar '25 adesivos - 2 Folhas A4'"
        )
    }

    func testStickerView_buttonOfRetornForHome() {
        // Arrange
        XCTAssertTrue(app.staticTexts["Imprimir Adesivo"].waitForExistence(timeout: 5))
        let returnButton = app.buttons["Voltar"]
        XCTAssertTrue(returnButton.waitForExistence(timeout: 3))

        // Act
        returnButton.tap()

        // Assert
        XCTAssertTrue(app.staticTexts["EyeSearch"].waitForExistence(timeout: 5),
                      "O botão 'Voltar' deve retornar para a HomeView")
    }

//    func testStickerView_botaoGerarPDFNavegaParaPrintStickerView() {
//        // Arrange
//        XCTAssertTrue(app.staticTexts["Imprimir Adesivo"].waitForExistence(timeout: 5))
//        let botaoGerar = app.buttons["Gerar PDF"]
//        XCTAssertTrue(botaoGerar.waitForExistence(timeout: 3))
//
//        // Act
//        botaoGerar.tap()
//
//        // Assert
//        // PrintStickerView exibe o botão de compartilhar
//        XCTAssertTrue(
//            app.buttons["- - - PDF"].waitForExistence(timeout: 5),
//            "Tocar em 'Gerar PDF' deve navegar para a PrintStickerView"
//        )
//    }
}
