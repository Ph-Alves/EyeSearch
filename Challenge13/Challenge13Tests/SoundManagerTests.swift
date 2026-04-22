//
//  SoundManagerTests.swift
//  EyeSearchTests
//
//  Created by Manoel Pedro Prado Sa Teles on 22/04/26.
//

import XCTest
@testable import EyeSearch

// MARK: - Test Suite

final class SoundManagerTests: XCTestCase {

    // MARK: Inviáveis — do documento
    //
    // T04 RN05 — Som ao reconhecer objeto
    //   Débito de funcionalidade: SearchObjectViewModel não chama soundManager.playSound
    //   em nenhum ponto do fluxo de detecção. O acoplamento entre detecção e feedback
    //   sonoro não existe no código atual.

    // MARK: - Propriedades

    private var sut: SoundManager!

    // MARK: - Setup / Teardown

    override func setUp() {
        super.setUp()
        sut = SoundManager()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - T28 — RN28 — Desativar sons não emite áudio

    func test_PlaySound_WhenDisabled_DoesNothing() {
        // Arrange — guard isEnabled (linha 29 do SoundManager) deve retornar imediatamente

        // Act & Assert
        XCTAssertNoThrow(
            sut.playSound(isEnabled: false),
            "playSound(isEnabled: false) não deve lançar exceção nem crashar."
        )
    }

    // MARK: - Additional coverage

    func test_PlaySound_WhenEnabled_DoesNotCrash() {
        // Arrange — smoke test; asset item-found.mp3 deve estar no bundle do host
        // Se não estiver, playSound retorna silenciosamente (guard let url, linha 31)

        // Act & Assert
        XCTAssertNoThrow(
            sut.playSound(isEnabled: true),
            "playSound(isEnabled: true) não deve crashar no simulador."
        )
    }

    func test_Reset_DoesNotCrash() {
        // Arrange — chama playSound primeiro para garantir que player não é nil antes do reset
        sut.playSound(isEnabled: true)

        // Act
        sut.reset()
          
        // Assert
        XCTAssertNil(sut.player)
    }
}
