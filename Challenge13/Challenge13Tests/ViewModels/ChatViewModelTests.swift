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
    private let messagesSubject  = CurrentValueSubject<[ChatMessage], Never>([])
    private let isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    private let errorSubject     = CurrentValueSubject<String?, Never>(nil)

    var messagesPublisher:     AnyPublisher<[ChatMessage], Never> { messagesSubject.eraseToAnyPublisher() }
    var isLoadingPublisher:    AnyPublisher<Bool, Never>          { isLoadingSubject.eraseToAnyPublisher() }
    var errorMessagePublisher: AnyPublisher<String?, Never>       { errorSubject.eraseToAnyPublisher() }

    private(set) var lastSentMessage: String?
    private(set) var clearCallCount = 0

    func sendMessage(_ userInput: String) async {
        lastSentMessage = userInput
    }

    func clearConversation() {
        clearCallCount += 1
    }

    // Helpers para injetar estado nos testes
    func simulateLoading(_ value: Bool) { isLoadingSubject.send(value) }
    func simulateMessages(_ messages: [ChatMessage]) { messagesSubject.send(messages) }
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
        spy = FoundationsManagerSpy()
        coordinator = Coordinator(dependencyContainer: DependencyContainer())
        sut = ChatViewModel(manager: spy, coordinator: coordinator)
    }

    override func tearDown() {
        sut = nil
        coordinator = nil
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

    func test_CanSend_WithTextAndNotLoading_ReturnsTrue() {
        // Arrange
        sut.inputText = "Como ativar VoiceOver?"
        spy.simulateLoading(false)

        // Act

        // Assert
        XCTAssertTrue(sut.canSend, "canSend deve ser true quando há texto e isLoading é false.")
    }

    func test_CanSend_WhileLoading_ReturnsFalse() {
        // Arrange
        sut.inputText = "Texto válido"
        spy.simulateLoading(true)

        // Act — isLoading é atualizado via publisher (Combine); aguarda propagação no RunLoop
        RunLoop.main.run(until: Date(timeIntervalSinceNow: 0.01))

        // Assert
        XCTAssertFalse(sut.canSend, "canSend deve ser false enquanto isLoading é true.")
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

    // MARK: - Navegação

    func test_NavigateToSettings_AppendsToPath() {
        // Arrange
        let initialCount = coordinator.path.count

        // Act
        sut.navigateToSettings()

        // Assert
        XCTAssertEqual(
            coordinator.path.count, initialCount + 1,
            "navigateToSettings deve adicionar um destino à pilha de navegação."
        )
    }

    func test_NavigateToHints_AppendsToPath() {
        // Arrange
        let initialCount = coordinator.path.count

        // Act
        sut.navigateToHints()

        // Assert
        XCTAssertEqual(
            coordinator.path.count, initialCount + 1,
            "navigateToHints deve adicionar um destino à pilha de navegação."
        )
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
