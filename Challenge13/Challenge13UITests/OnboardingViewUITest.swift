//
//  EyeSearchUITests.swift
//  EyeSearchUITests
//
//  Created by Daniela Valadares on 27/04/26.
//

import XCTest

final class OnboardingViewUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        // Garante que o onboarding seja exibido ao resetar o flag
        app.launchArguments += ["-hasCompletedOnboarding", "false"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testOnboardingView_exhibitionContinueButton() {
        // Arrange
        // App iniciado com onboarding não concluído (setUp)

        // Act
        // Nenhuma ação necessária — tela exibida ao abrir

        // Assert
        XCTAssertTrue(app.buttons["Continuar"].exists, "O botão 'Continuar' deve estar visível na primeira página")
    }

    func testOnboardingView_firtPageExhibitonContents() {
        // Arrange
        // App iniciado na primeira página do onboarding

        // Act
        // Nenhuma ação necessária

        // Assert
        // Verifica que há pelo menos um texto de título renderizado na tela
        let titles = app.staticTexts.allElementsBoundByIndex
        XCTAssertTrue(titles.count > 0, "A primeira página deve exibir ao menos um texto de título")
    }

    func testOnboardingView_buttonContinueAdvanceToTheNextPage() {
        // Arrange
        let continueButton = app.buttons["Continuar"]
        XCTAssertTrue(continueButton.waitForExistence(timeout: 3))

        // Act
        continueButton.tap()

        // Assert
        // Após avançar, o botão ainda deve existir (páginas intermediárias)
        XCTAssertTrue(app.buttons["Continuar"].waitForExistence(timeout: 2), "O botão 'Continuar' deve permanecer visível nas páginas intermediárias")
    }

    func testOnboardingView_navigateThroughAllPagesWithSwipe() {
        // Arrange
        let tabView = app.cells/*@START_MENU_TOKEN@*/.firstMatch/*[[".containing(.other, identifier: nil).firstMatch",".firstMatch"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCTAssertTrue(tabView.waitForExistence(timeout: 5))

        // Act
        for _ in 0..<4 {
            tabView.swipeLeft()
        }

        // Assert
        XCTAssertTrue(app.buttons["Começar"].waitForExistence(timeout: 3),
                      "O botão da última página deve exibir 'Começar'")
    }

    func testOnboardingView_buttonStarteInTheLastPage() {
        // Arrange
        XCTAssertTrue(app.buttons["Continuar"].waitForExistence(timeout: 6))

        // Act — avança até a última página pelo botão (sem depender do tabView)
        for _ in 0..<4 {
            let button = app.buttons["Continuar"]
            if button.waitForExistence(timeout: 2) { button.tap() }
        }

        // Assert
        XCTAssertTrue(app.buttons["Começar"].waitForExistence(timeout: 3),
                      "Na última página deve aparecer o botão 'Começar'")
    }

    func testOnboardingView_goToHomeViewWhenTheOnboardingIsOver() {
        // Arrange
        testOnboardingView_navigateThroughAllPagesWithSwipe()
        
        
        
        let startButton = app.buttons["Começar"]
        XCTAssertTrue(startButton.waitForExistence(timeout: 3))

        // Act
        startButton.tap()
//        app/*@START_MENU_TOKEN@*/.buttons["Começar"]/*[[".otherElements.buttons[\"Começar\"]",".buttons",".buttons[\"Começar\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        
        // Assert
        XCTAssertTrue(app.navigationBars["EyeSearch"].waitForExistence(timeout: 5),
                      "Após concluir o onboarding, a HomeView deve ser exibida")
        
    }
}
