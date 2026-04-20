//
//  ChatViewModel.swift
//  Challenge13
//
//  Created by Daniela Valadares on 16/04/26.
//

import Foundation
import Combine

@MainActor
final class ChatViewModel: ObservableObject {

    @Published var displayedMessages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorBanner: String? = nil
    @Published var showClearConfirmation: Bool = false

    private let manager: FoundationsManager
    private let coordinator: Coordinator
    private var cancellables = Set<AnyCancellable>()

    /// Indica se o botão de envio deve estar habilitado.
    var canSend: Bool {
        !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading
    }

    /// Texto de acessibilidade do status atual para VoiceOver.
    var loadingAccessibilityLabel: String {
        isLoading ? "Assistente está digitando, aguarde." : ""
    }

    /// Init padrão: cria o manager internamente.
    /// Usado pelo @StateObject na ChatView.
    init(coordinator: Coordinator) {
        self.manager = FoundationsManager()
        self.coordinator = coordinator
        bindManager()
    }

    /// Init com injeção de dependência
    init(manager: FoundationsManager, coordinator: Coordinator) {
        self.manager = manager
        self.coordinator = coordinator
        bindManager()
    }

    // MARK: - Binding com o Manager

    /// Observa as propriedades publicadas do manager e repassa para a View.
    private func bindManager() {
        manager.$messages
            .receive(on: RunLoop.main)
            .assign(to: &$displayedMessages)

        manager.$isLoading
            .receive(on: RunLoop.main)
            .assign(to: &$isLoading)

        manager.$errorMessage
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.errorBanner = error
                // Auto-dismiss após 6 segundos
                if error != nil {
                    Task { @MainActor in
                        try? await Task.sleep(for: .seconds(6))
                        self?.errorBanner = nil
                    }
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Intenções da View

    /// Chamado quando o usuário pressiona "Enviar".
    func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        inputText = ""
        Task {
            await manager.sendMessage(text)
        }
    }

    /// Chamado ao pressionar Enter no teclado.
    func handleSubmit() {
        guard canSend else { return }
        sendMessage()
    }

    /// Solicita confirmação para limpar conversa.
    func requestClear() {
        showClearConfirmation = true
    }

    /// Confirma e executa a limpeza.
    func confirmClear() {
        manager.clearConversation()
        showClearConfirmation = false
    }

    // MARK: - Navegação (via Coordinator)
    
    func navigateToSettings() {
        coordinator.navigate(to: .settings)
    }

    func navigateToHints() {
        coordinator.navigate(to: .hints)
    }

    // MARK: - Ajudantes de apresentação

    /// Rótulo de acessibilidade completo para uma mensagem.
    func accessibilityLabel(for message: ChatMessage) -> String {
        let role = message.role == .user ? "Você disse" : "Assistente respondeu"
        let filtered = message.isFiltered ? " (mensagem fora do escopo)" : ""
        return "\(role): \(message.text)\(filtered)"
    }

    /// Limpa a conversa ao sair da tela.
    func onViewDisappear() {
        manager.clearConversation()
    }
}
