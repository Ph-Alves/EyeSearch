//
//  IntentsManagerTests.swift
//  EyeSearchTests
//
//  Created by Manoel Pedro Prado Sa Teles on 22/04/26.
//

import XCTest
import SwiftUI
@testable import EyeSearch

// MARK: - Test Suite

final class IntentsManagerTests: XCTestCase {

    // MARK: Inviáveis — do documento
    //
    // T17 RN19 — Intent "Gerar adesivo" inicia geração de PDF
    //   Débito de funcionalidade: apenas OpenSearchObjectIntent existe.
    //   Não há intent de geração de PDF implementada.

    // MARK: - Propriedades

    // IntentsManager é singleton (private init) — todos os testes compartilham a mesma instância.
    // tearDown limpa coordinator para garantir isolamento entre testes.
    private var coordinator: Coordinator!

    // MARK: - Setup / Teardown

    override func setUp() {
        super.setUp()
        coordinator = Coordinator(dependencyContainer: DependencyContainer())
    }

    override func tearDown() {
        IntentsManager.shared.coordinator = nil
        coordinator = nil
        super.tearDown()
    }

    // MARK: - T16 — RN19 — Intent "Procurar adesivo" / Additional: path vazio

    @MainActor
    func test_OpenSearchObject_WithEmptyPath_NavigatesToSearchObject() {
        // Arrange
        IntentsManager.shared.coordinator = coordinator
        XCTAssertTrue(coordinator.path.isEmpty, "Pré-condição: path deve estar vazio.")

        // Act
        IntentsManager.shared.openSearchObject()

        // Assert
        XCTAssertEqual(
            coordinator.path.count, 1,
            "path deve ter 1 elemento após navegar para .searchObject."
        )
    }

    // MARK: - Additional coverage

    @MainActor
    func test_OpenSearchObject_WithoutCoordinator_DoesNothing() {
        // Arrange — coordinator não atribuído (nil via tearDown já garante, mas explicitamos)
        IntentsManager.shared.coordinator = nil

        // Act & Assert — guard let coordinator (linha 33) deve retornar silenciosamente
        XCTAssertNoThrow(
            IntentsManager.shared.openSearchObject(),
            "openSearchObject sem coordinator não deve lançar exceção."
        )
    }

    @MainActor
    func test_OpenSearchObject_WithPopulatedPath_PopsToRootThenNavigates() {
        // Arrange
        IntentsManager.shared.coordinator = coordinator
        coordinator.navigate(to: .hints)
        coordinator.navigate(to: .settings)
        XCTAssertEqual(coordinator.path.count, 2, "Pré-condição: path deve ter 2 elementos.")

        // Act
        IntentsManager.shared.openSearchObject()

        // Assert — branch linha 34: popToRoot() + navigate(.searchObject) = 1 item final
        XCTAssertEqual(
            coordinator.path.count, 1,
            "path deve ter apenas 1 elemento após popToRoot + navigate(.searchObject)."
        )
    }
}
