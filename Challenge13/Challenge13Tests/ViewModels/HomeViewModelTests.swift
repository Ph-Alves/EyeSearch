//
//  HomeViewModelTests.swift
//  EyeSearchTests
//
//  Created by Manoel Pedro Prado Sa Teles on 24/04/26.
//

import XCTest
@testable import EyeSearch

final class HomeViewModelTests: XCTestCase {

    // MARK: - Propriedades

    private var sut: HomeViewModel!

    // MARK: - Setup / Teardown

    @MainActor
    override func setUp() {
        super.setUp()
        sut = HomeViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Additional coverage

    @MainActor
    func test_GenerateItems_ReturnsFourItems() {
        // Arrange — HomeViewModel recém-criado

        // Act
        let items = sut.generateItems()

        // Assert
        XCTAssertEqual(items.count, 4, "generateItems deve retornar exatamente 4 itens.")
    }

    @MainActor
    func test_GenerateItems_HasCorrectDestinations() {
        // Arrange
        let expectedDestinations: [HomeDestination] = [.searchObject, .stickerConfig, .hints, .settings]

        // Act
        let items = sut.generateItems()

        // Assert
        let destinations = items.map { $0.screen }
        XCTAssertEqual(
            destinations,
            expectedDestinations,
            "generateItems deve retornar destinos na ordem: searchObject, stickerConfig, hints, settings."
        )
    }
}
