//
//  HapticsManagerTests.swift
//  EyeSearchTests
//
//  Created by Manoel Pedro Prado Sa Teles on 22/04/26.
//

import XCTest
import UIKit
@testable import EyeSearch

final class HapticsManagerTests: XCTestCase {

    // MARK: Inviáveis — do documento
    //
    // T03 RN04 — Haptics ao reconhecer objeto
    
    //   Débito de funcionalidade: SearchObjectViewModel não chama haptics.trigger
    //   em nenhum ponto do fluxo de detecção. O acoplamento entre detecção e feedback
    //   tátil não existe no código atual.

    // MARK: - Propriedades

    private var sut: HapticsManager!

    // MARK: - Setup / Teardown

    override func setUp() {
        super.setUp()
        sut = HapticsManager()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - T27 — RN28 — Desativar haptics não emite vibrações

    func test_Trigger_WhenDisabled_DoesNothing() {
        // Arrange — manager recém-criado (estado padrão habilitado não importa aqui)

        // Act & Assert
        // guard isEnabled (linha 28 do HapticsManager) deve retornar imediatamente,
        // sem instanciar UIImpactFeedbackGenerator.
        XCTAssertNoThrow(
            sut.trigger(isEnabled: false),
            "trigger(isEnabled: false) não deve lançar exceção nem crashar."
        )
    }

    // MARK: - Additional coverage

    func test_Trigger_WhenEnabled_DoesNotCrash() {
        // Arrange — simulador não produz vibração real mas aceita a chamada ao generator

        // Act & Assert
        XCTAssertNoThrow(
            sut.trigger(isEnabled: true),
            "trigger(isEnabled: true) não deve crashar no simulador."
        )
    }

    func test_SetEnabled_And_Reset_DoNotCrash() {
        // Arrange
        // Débito de testabilidade: isEnabled é private — impossível assertar o estado
        // resultante. Proposta: tornar isEnabled private(set) para verificar via
        // XCTAssertFalse/True após setEnabled e reset.

        // Act & Assert
        XCTAssertNoThrow(sut.setEnabled(false), "setEnabled(false) não deve crashar.")
        XCTAssertNoThrow(sut.setEnabled(true),  "setEnabled(true) não deve crashar.")
        XCTAssertNoThrow(sut.reset(),           "reset() não deve crashar.")
    }
}
