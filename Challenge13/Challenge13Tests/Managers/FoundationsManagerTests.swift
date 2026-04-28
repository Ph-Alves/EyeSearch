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

    private var sut: FoundationsManager!
    private var cancellables: Set<AnyCancellable>!

    // MARK: - Setup / Teardown

    override func setUp() {
        super.setUp()
        sut = FoundationsManager()
        cancellables = []
    }

    override func tearDown() {
        cancellables = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - Estado inicial

    func test_MessagesPublisher_InitiallyEmpty() {
        var messages: [ChatMessage]?
        sut.messagesPublisher
            .first()
            .sink { messages = $0 }
            .store(in: &cancellables)

        XCTAssertEqual(
            messages?.count, 0,
            "messagesPublisher deve emitir array vazio na criação do manager."
        )
    }

    func test_IsLoadingPublisher_InitiallyFalse() {
        var isLoading: Bool?
        sut.isLoadingPublisher
            .first()
            .sink { isLoading = $0 }
            .store(in: &cancellables)

        XCTAssertEqual(
            isLoading, false,
            "isLoadingPublisher deve emitir false antes de qualquer sendMessage."
        )
    }

    // MARK: - sendMessage — guarda de entrada

    func test_SendMessage_WithEmptyString_DoesNotAppendMessage() async {
        await sut.sendMessage("")

        var messages: [ChatMessage]?
        sut.messagesPublisher
            .first()
            .sink { messages = $0 }
            .store(in: &cancellables)

        XCTAssertTrue(
            messages?.isEmpty == true,
            "sendMessage com string vazia não deve adicionar nenhuma mensagem ao histórico."
        )
    }

    func test_SendMessage_WithWhitespaceOnly_DoesNotAppendMessage() async {
        await sut.sendMessage("   ")

        var messages: [ChatMessage]?
        sut.messagesPublisher
            .first()
            .sink { messages = $0 }
            .store(in: &cancellables)

        XCTAssertTrue(
            messages?.isEmpty == true,
            "sendMessage com apenas espaços em branco não deve adicionar mensagem ao histórico."
        )
    }

    // MARK: - sendMessage — comportamento observável independente do modelo

    func test_SendMessage_AppendsUserMessage() async {
        await sut.sendMessage("como usar o app")

        var messages: [ChatMessage]?
        sut.messagesPublisher
            .first()
            .sink { messages = $0 }
            .store(in: &cancellables)

        XCTAssertTrue(
            messages?.contains { $0.role == .user && $0.text == "como usar o app" } == true,
            "sendMessage deve adicionar a mensagem do usuário ao histórico."
        )
    }

    func test_SendMessage_IsLoadingReturnsFalseAfterCompletion() async {
        // isLoading é resetado em todos os caminhos: sucesso, erro tipado e erro genérico.
        await sut.sendMessage("como usar o app")

        var isLoading: Bool?
        sut.isLoadingPublisher
            .first()
            .sink { isLoading = $0 }
            .store(in: &cancellables)

        XCTAssertEqual(
            isLoading, false,
            "isLoading deve retornar a false após sendMessage concluir."
        )
    }

    func test_SendMessage_MultipleMessages_AccumulatesHistory() async {
        await sut.sendMessage("primeira pergunta")
        await sut.sendMessage("segunda pergunta")

        var messages: [ChatMessage]?
        sut.messagesPublisher
            .first()
            .sink { messages = $0 }
            .store(in: &cancellables)

        let userMessages = messages?.filter { $0.role == .user } ?? []
        XCTAssertEqual(
            userMessages.count, 2,
            "Cada sendMessage deve acumular sua mensagem de usuário no histórico."
        )
    }

    // MARK: - clearConversation

    func test_ClearConversation_ResetsMessagesHistory() async {
        // Arrange — popula o histórico
        await sut.sendMessage("como usar o app")

        // Act
        sut.clearConversation()

        // Assert
        var messages: [ChatMessage]?
        sut.messagesPublisher
            .first()
            .sink { messages = $0 }
            .store(in: &cancellables)

        XCTAssertTrue(
            messages?.isEmpty == true,
            "clearConversation deve remover todas as mensagens do histórico."
        )
    }

    func test_ClearConversation_WhenEmpty_DoesNotCrash() {
        XCTAssertNoThrow(
            sut.clearConversation(),
            "clearConversation em histórico vazio não deve crashar."
        )
    }

    func test_ClearConversation_CalledMultipleTimes_DoesNotCrash() async {
        await sut.sendMessage("como usar o app")
        sut.clearConversation()

        XCTAssertNoThrow(
            sut.clearConversation(),
            "clearConversation chamado múltiplas vezes não deve crashar."
        )
    }
}
