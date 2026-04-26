//
//  HintsViewModelTests.swift
//  EyeSearchTests
//
//  Created by Manoel Pedro Prado Sa Teles on 24/04/26.
//

import XCTest
@testable import EyeSearch

final class HintsViewModelTests: XCTestCase {

    // MARK: Inviáveis — do documento
    //
    // T25 RN26 — Dynamic Type / layout
    //   UI test: verificação de layout responsivo, fora do escopo de unit test.

    // MARK: - Propriedades

    private var sut: HintsViewModel!

    // MARK: - Setup / Teardown

    override func setUp() {
        super.setUp()
        sut = HintsViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Additional coverage

    func test_Init_HasThreeDefaultHints() {
        // Arrange — HintsViewModel recém-criado

        // Act — (nenhuma ação; apenas leitura do estado inicial)

        // Assert
        XCTAssertEqual(sut.hints.count, 3, "hints deve conter exatamente 3 dicas na inicialização.")
        XCTAssertNil(sut.selectedHintID, "selectedHintID deve ser nil na inicialização.")
    }

    // MARK: - T24 — RN26 — Clique em card expande

    func test_ToggleHint_OnClosedHint_SetsSelectedID() {
        // Arrange
        let hint = sut.hints[0]
        XCTAssertNil(sut.selectedHintID, "Pré-condição: nenhuma dica deve estar aberta.")

        // Act
        sut.toggleHint(hint)

        // Assert
        XCTAssertEqual(sut.selectedHintID, hint.id, "toggleHint deve definir selectedHintID para o id da dica tocada.")
    }

    func test_ToggleHint_OnOpenHint_ClearsSelectedID() {
        // Arrange — abre a dica primeiro
        let hint = sut.hints[1]
        sut.toggleHint(hint)
        XCTAssertEqual(sut.selectedHintID, hint.id, "Pré-condição: dica deve estar aberta.")

        // Act — toca a mesma dica novamente
        sut.toggleHint(hint)

        // Assert
        XCTAssertNil(sut.selectedHintID, "Ao tocar uma dica aberta, selectedHintID deve voltar a nil.")
    }

    func test_ToggleHint_BetweenDifferentHints_ReplacesSelectedID() {
        // Arrange — abre a primeira dica
        let firstHint  = sut.hints[0]
        let secondHint = sut.hints[1]
        sut.toggleHint(firstHint)
        XCTAssertEqual(sut.selectedHintID, firstHint.id, "Pré-condição: primeira dica deve estar aberta.")

        // Act — toca uma dica diferente
        sut.toggleHint(secondHint)

        // Assert
        XCTAssertEqual(
            sut.selectedHintID, secondHint.id,
            "Ao tocar uma dica diferente, selectedHintID deve ser substituído pelo id da nova dica."
        )
    }
}
