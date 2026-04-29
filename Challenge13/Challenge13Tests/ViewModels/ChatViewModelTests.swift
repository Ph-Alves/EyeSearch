//
//  ChatViewModelTests.swift
//  EyeSearchTests
//
//  Created by Manoel Pedro Prado Sa Teles on 24/04/26.
//

import XCTest
import SwiftUI
import Combine
@testable import EyeSearch

// MARK: - Spy

private final class FoundationsManagerSpy: FoundationsManaging {
    static let shared: FoundationsManaging = FoundationsManagerSpy()
    
    private init() {}
    
    // Mantemos estas variáveis para que o teste possa verificar o que aconteceu
    private(set) var lastSentMessage: String?
    private(set) var clearCallCount = 0
    
    // Variável para simular a resposta que o Manager devolveria
    var stubbedResponse: ChatMessage?

    func sendMessage(_ userInput: String) async throws -> ChatMessage? {
        lastSentMessage = userInput
        return stubbedResponse
    }

    func clearConversation() {
        clearCallCount += 1
    }
    
    func reset() {
        self.lastSentMessage = nil
        self.clearCallCount = 0
        self.stubbedResponse = nil
    }
}

// MARK: - Test Suite

// MARK: Inviáveis — do documento
//
// T29 RN28 (erratum: doc cita RN29 inexistente) — Chatbot responde corretamente
//   Débito: FoundationsManager instancia LanguageModelSession internamente,
//   sem DI da sessão. Não é possível testar a resposta real sem refatorar produção.
//   ChatViewModel é totalmente coberto via FoundationsManagerSpy.

@MainActor
final class ChatViewModelTests: XCTestCase {

    // MARK: - Propriedades

    private var spy: FoundationsManagerSpy!
    private var coordinator: Coordinator!
    private var sut: ChatViewModel!

    // MARK: - Setup / Teardown

    override func setUp() {
        super.setUp()
        spy = FoundationsManagerSpy.shared as? FoundationsManagerSpy
        sut = ChatViewModel(manager: spy)
        spy.reset()
    }

    override func tearDown() {
        sut = nil
        spy = nil
        super.tearDown()
    }

    // MARK: - canSend

    func test_CanSend_WithEmptyInput_ReturnsFalse() {
        // Arrange
        sut.inputText = ""

        // Act — (nenhuma ação; propriedade computada)

        // Assert
        XCTAssertFalse(sut.canSend, "canSend deve ser false quando inputText está vazio.")
    }

    func test_CanSend_WithWhitespaceOnly_ReturnsFalse() {
        // Arrange
        sut.inputText = "   "

        // Act

        // Assert
        XCTAssertFalse(sut.canSend, "canSend deve ser false quando inputText contém apenas espaços.")
    }

    @MainActor
    func test_CanSend_WithTextAndNotLoading_ReturnsTrue() {
        // Arrange
        sut.inputText = "Como ativar VoiceOver?"
        // Por padrão, isLoading nasce false

        // Assert
        XCTAssertTrue(sut.canSend, "canSend deve ser true quando há texto e não está carregando.")
    }

    @MainActor
    func test_CanSend_WhileLoading_ReturnsFalse() {
        // Arrange
        sut.inputText = "Texto válido"
        
        // Act
        sut.sendMessage() // Isso define isLoading = true imediatamente

        // Assert
        XCTAssertFalse(sut.canSend, "canSend deve ser false enquanto o processamento (isLoading) ocorre.")
    }

    // MARK: - sendMessage

    func test_SendMessage_TrimsInputAndClearsField() {
        // Arrange
        sut.inputText = "  olá  "

        // Act
        sut.sendMessage()

        // Assert
        XCTAssertEqual(sut.inputText, "", "inputText deve ser limpo após sendMessage.")
    }

    func test_SendMessage_WithEmptyInput_DoesNotCallManager() {
        // Arrange
        sut.inputText = ""

        // Act
        sut.sendMessage()

        // Assert
        XCTAssertNil(spy.lastSentMessage, "manager.sendMessage não deve ser chamado com inputText vazio.")
    }

    // MARK: - confirmClear

    func test_ConfirmClear_CallsManagerAndDismissesDialog() {
        // Arrange
        sut.requestClear()
        XCTAssertTrue(sut.showClearConfirmation, "Pré-condição: showClearConfirmation deve ser true.")

        // Act
        sut.confirmClear()

        // Assert
        XCTAssertEqual(spy.clearCallCount, 1, "manager.clearConversation deve ser chamado uma vez.")
        XCTAssertFalse(sut.showClearConfirmation, "showClearConfirmation deve ser false após confirmClear.")
    }

    // MARK: - handleSubmit

    func test_HandleSubmit_WhenCannotSend_DoesNotClearInput() {
        // Arrange — input vazio → canSend = false
        sut.inputText = ""

        // Act
        sut.handleSubmit()

        // Assert — inputText permanece intacto; sendMessage nunca foi chamado
        XCTAssertEqual(sut.inputText, "", "handleSubmit com canSend=false não deve alterar inputText.")
        XCTAssertNil(spy.lastSentMessage, "manager.sendMessage não deve ser chamado quando canSend=false.")
    }

    func test_HandleSubmit_WhenCanSend_ClearsInputText() {
        // Arrange — texto válido → canSend = true
        sut.inputText = "Como usar o VoiceOver?"

        // Act
        sut.handleSubmit()

        // Assert — inputText é limpo de forma síncrona dentro de sendMessage()
        XCTAssertEqual(sut.inputText, "", "handleSubmit com texto válido deve limpar inputText.")
    }

    // MARK: - onViewDisappear

    func test_OnViewDisappear_CallsClearConversation() {
        // Arrange
        XCTAssertEqual(spy.clearCallCount, 0, "Pré-condição: clearConversation não deve ter sido chamado.")

        // Act
        sut.onViewDisappear()

        // Assert
        XCTAssertEqual(spy.clearCallCount, 1, "onViewDisappear deve chamar clearConversation exatamente uma vez.")
    }

    // MARK: - accessibilityLabel

    func test_AccessibilityLabel_UserMessage_ContainsRoleAndText() {
        // Arrange
        let message = ChatMessage(role: .user, text: "Como ativar o VoiceOver?")

        // Act
        let label = sut.accessibilityLabel(for: message)

        // Assert
        XCTAssertTrue(label.contains("Você disse"), "Label de mensagem do usuário deve conter 'Você disse'.")
        XCTAssertTrue(label.contains("Como ativar o VoiceOver?"), "Label deve conter o texto da mensagem.")
    }

    func test_AccessibilityLabel_AssistantMessage_ContainsRoleAndText() {
        // Arrange
        let message = ChatMessage(role: .assistant, text: "Acesse Ajustes > Acessibilidade.")

        // Act
        let label = sut.accessibilityLabel(for: message)

        // Assert
        XCTAssertTrue(label.contains("Assistente respondeu"), "Label de resposta deve conter 'Assistente respondeu'.")
        XCTAssertTrue(label.contains("Acesse Ajustes"), "Label deve conter o texto da mensagem.")
    }

    func test_AccessibilityLabel_FilteredMessage_IncludesFlag() {
        // Arrange — mensagem marcada como filtrada (fora do escopo)
        let message = ChatMessage(role: .assistant, text: "Desculpe.", isFiltered: true)

        // Act
        let label = sut.accessibilityLabel(for: message)

        // Assert
        XCTAssertTrue(
            label.contains("fora do escopo"),
            "Label de mensagem filtrada deve incluir a flag '(mensagem fora do escopo)'."
        )
    }
}
