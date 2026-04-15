//
//  MLModelManagerTests.swift
//  EyeSearchTests
//
//  Created by Manoel Pedro Prado Sa Teles on 15/04/26.
//

import XCTest
@testable import Challenge13

final class MLModelManagerTests: XCTestCase {
    
    // MARK: - T31 — Verificar se o singleton retorna a mesma instância
    
    func testSingletonReturnsSameInstance() {
        // Arrange
        let instance1 = MLModelManager.manager
        let instance2 = MLModelManager.manager
        
        // Act & Assert
        XCTAssertTrue(instance1 === instance2, "MLModelManager.manager deve retornar a mesma instância sempre.")
    }
    
    // MARK: - T30 — Verificar se os modelos ML carregam corretamente
    
    func testModelsLoadSuccessfully() {
        // Arrange
        let manager = MLModelManager.manager
        let expectation = expectation(description: "Modelos devem carregar em background")
        
        // Act
        // Os modelos carregam no init() via DispatchQueue.global
        // Precisamos esperar o carregamento completar
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
        
        // Assert
        XCTAssertTrue(manager.isLoaded, "isLoaded deve ser true após carregamento dos modelos.")
        XCTAssertNil(manager.error, "error deve ser nil quando os modelos carregam com sucesso.")
        XCTAssertNotNil(manager.stickerModel, "stickerModel não deve ser nil após carregamento.")
        XCTAssertNotNil(manager.yoloModel, "yoloModel não deve ser nil após carregamento.")
    }
}
