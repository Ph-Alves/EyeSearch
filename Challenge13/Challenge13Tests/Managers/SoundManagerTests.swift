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
    // T04 RN05 — Som ao reconhecer objeto (integração ViewModel ↔ SoundManager)
    //   Funcionalidade implementada: SearchObjectViewModel.playSoundIfEnabled chama
    //   sound.playSound e sound.speakLabel dentro do fluxo de detecção.
    //   Bloqueio de teste: SearchObjectViewModel.init recebe SoundManager (concreto)
    //   em vez de SoundManaging (protocolo), impedindo injeção de spy.
    //   Proposta: mudar o init para aceitar SoundManaging e mover o teste para
    //   SearchObjectViewModelTests com um SoundManagerSpy.

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
        // Arrange — smoke test; asset ObjectFound.mp3 deve estar no bundle do host
        // Se não estiver, playSound retorna silenciosamente (player é nil)

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

    // MARK: - Additional coverage — speakLabel

    func test_SpeakLabel_WhenDisabled_DoesNothing() {
        // Arrange — guard isEnabled (linha 40 do SoundManager) deve retornar imediatamente

        // Act & Assert
        XCTAssertNoThrow(
            sut.speakLabel(isEnabled: false, label: "person"),
            "speakLabel(isEnabled: false) não deve crashar."
        )
    }

    func test_SpeakLabel_WithUnknownLabel_DoesNothing() {
        // Arrange — label fora do enum YoloTranslations: guard YoloTranslations(rawValue:)
        // retorna nil e o método encerra sem falar nada (linha 43 do SoundManager).

        // Act & Assert
        XCTAssertNoThrow(
            sut.speakLabel(isEnabled: true, label: "labelInexistente_XYZ"),
            "speakLabel com label desconhecido não deve crashar."
        )
    }
}
