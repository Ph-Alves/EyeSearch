//
//  FoundationsManagerTests.swift
//  EyeSearchTests
//
//  Created by Manoel Pedro Prado Sa Teles on 26/04/26.
//

import XCTest
import Combine
@testable import EyeSearch

// MARK: - Test Suite

@MainActor
final class FoundationsManagerTests: XCTestCase {

    // MARK: Inviáveis
    //
    // T_FullFlow — session.respond requer Apple Intelligence (iPhone 15 Pro+, iOS 18.1+)
    //   LanguageModelSession não é injetável sem protocolo próprio.
    //   Proposta: extrair LanguageModelSessioning e injetar no init para permitir stubbing.
    //
    // T_FilteredMessage — Verificar que sendMessage appenda isFiltered = true em caso de erro
    //   SystemLanguageModel.default.isAvailable retorna true no simulador (Xcode 16+):
    //   session.respond() executa de verdade e retorna resposta real sem erro. Não é possível
    //   forçar o caminho de erro sem injetar uma sessão que falhe de forma controlada.
    //
    // T_LocalScopeCheck — localScopeCheck é privado e atualmente retorna nil em todos
    //   os ramos (lógica de filtragem simplificada). Testável via acesso internal + @testable.
    //
    // T_ProcessModelResponse — processModelResponse é privado; detecção de FORA_DO_ESCOPO
    //   só é exercitável com sessão ativa e resposta controlada do modelo.

    // MARK: - Propriedades

    private var sut: FoundationsManaging!
    private var cancellables: Set<AnyCancellable>!

    // MARK: - Setup / Teardown

    override func setUp() {
        super.setUp()
        sut = FoundationsManager.shared
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - sendMessage — comportamento observável independente do modelo

    func test_SendMessage_WithEmptyString_ReturnsNil() async throws {
        // Act
        let response = try await sut.sendMessage("")

        // Assert
        XCTAssertNil(response, "String vazia não deve gerar resposta ou processamento.")
    }

    func test_SendMessage_WithWhitespaceOnly_ReturnsNil() async throws {
        // Act
        let response = try await sut.sendMessage("   ")

        // Assert
        XCTAssertNil(response, "Apenas espaços não devem gerar resposta.")
    }

    func test_SendMessage_AppendsUserMessage_AndReturnsResponse() async throws {
        // Como o Manager real depende do Apple Intelligence,
        // esse teste validará o retorno (seja a resposta do modelo ou erro de escopo)
        
        let response = try await sut.sendMessage("Como ativar o VoiceOver?")
        
        XCTAssertNotNil(response, "Deveria retornar uma resposta (ou mensagem de erro de escopo).")
        XCTAssertEqual(response?.role, .assistant)
    }

    // MARK: - clearConversation

    func test_ClearConversation_DoesNotCrash() {
        // Act & Assert
        XCTAssertNoThrow(sut.clearConversation(), "Reiniciar a sessão não deve causar erros.")
    }
}
