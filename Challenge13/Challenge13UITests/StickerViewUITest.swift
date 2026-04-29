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
        XCTAssertTrue(stickerCard.waitForExistence(timeout: 5),
                      "Card 'Adesivos' deve existir na HomeView para navegar")
        stickerCard.tap()
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
        XCTAssertTrue(app.staticTexts["Adesivos"].waitForExistence(timeout: 5),
                      "StickerView deve exibir o título 'Adesivos' no Header")
    }

    func testStickerView_exhibitionDescriptionView() {
        // Arrange
        // Já na StickerView (setUp)

        // Act
        // Nenhuma ação necessária

        // Assert
        XCTAssertTrue(
            app.staticTexts["Este é o adesivo que identificará seus objetos.\nEscolha a quantidade que deseja imprimir."].waitForExistence(timeout: 5),
            "StickerView deve exibir a descrição no Header"
        )
    }

    func testStickerView_exhibitionStickerImage() {
        // Arrange
        // Já na StickerView (setUp)

        // Act
        // Nenhuma ação necessária

        // Assert
        XCTAssertTrue(app.images["adesivoPrinter"].waitForExistence(timeout: 5),
                      "StickerView deve exibir a imagem do adesivo")
    }

    func testStickerView_exhibitionQuantityLabel() {
        // Arrange
        // Já na StickerView (setUp)

        // Act
        // Nenhuma ação necessária

        // Assert
        XCTAssertTrue(app.staticTexts["Quantidade:"].waitForExistence(timeout: 5),
                      "StickerView deve exibir o label 'Quantidade:'")
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

    func testStickerView_exhibitionButtonToGeneratePDF() {
        // Arrange
        // Já na StickerView (setUp)

        // Act
        // Nenhuma ação necessária

        // Assert
        XCTAssertTrue(app.buttons["Imprimir"].waitForExistence(timeout: 5),
                      "StickerView deve exibir o botão 'Imprimir'")
    }

    func testStickerView_buttonPlusIncreaseQuantity() {
        // Arrange
        XCTAssertTrue(app.staticTexts["1"].waitForExistence(timeout: 5))
        let plusButton = app.buttons["StepperPlusButton"]
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
        let plusButton = app.buttons["StepperPlusButton"]
        XCTAssertTrue(plusButton.waitForExistence(timeout: 3))
        plusButton.tap() // vai para 2
        XCTAssertTrue(app.staticTexts["2"].waitForExistence(timeout: 3))
        let minusButton = app.buttons["StepperMinusButton"]
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
        let minusButton = app.buttons["StepperMinusButton"]
        XCTAssertTrue(minusButton.waitForExistence(timeout: 3))
 
        // Act
        minusButton.tap() // tenta decrementar abaixo de 1
 
        // Assert
        XCTAssertTrue(app.staticTexts["1"].waitForExistence(timeout: 3),
                      "A quantidade não deve ser menor que 1")
    }

    func testStickerView_buttonOfReturnForHome() {
        // Arrange
        XCTAssertTrue(app.staticTexts["Adesivos"].waitForExistence(timeout: 5))
        let returnButton = app.buttons["Voltar"]
        XCTAssertTrue(returnButton.waitForExistence(timeout: 3))

        // Act
        returnButton.tap()

        // Assert
        XCTAssertTrue(app.staticTexts["EyeSearch"].waitForExistence(timeout: 5),
                      "O botão 'Voltar' no Header deve retornar para a HomeView")
    }

//    func testStickerView_botaoGerarPDFNavegaParaPrintStickerView() {
//        // Arrange
//        XCTAssertTrue(app.staticTexts["Adesivos"].waitForExistence(timeout: 5))
//        let botaoGerar = app.buttons["Imprimir"]
//        XCTAssertTrue(botaoGerar.waitForExistence(timeout: 3))
//
//        // Act
//        botaoGerar.tap()
//
//        // Assert
//        // PrintStickerView exibe o botão de compartilhar
//        XCTAssertTrue(
//            app.buttons["- - - PDF"].waitForExistence(timeout: 5),
//            "Tocar em 'Imprimir' deve navegar para a PrintStickerView"
//        )
//    }
}
