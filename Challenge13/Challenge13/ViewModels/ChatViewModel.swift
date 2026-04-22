//
//  ChatViewModel.swift
//  Challenge13
//
//  Created by Daniela Valadares on 16/04/26.
//

import Foundation

@Observable
final class ChatViewModel {

    var inputText: String = ""
    var errorBanner: String? = nil
    var showClearConfirmation: Bool = false

    private let manager: FoundationsManager
    private let coordinator: Coordinator

    /// Mensagens vindas diretamente do manager (fonte única de verdade).
    var displayedMessages: [ChatMessage] {
        manager.messages
    }

    /// Estado de loading vindo diretamente do manager.
    var isLoading: Bool {
        manager.isLoading
    }

    /// Indica se o botão de envio deve estar habilitado.
    var canSend: Bool {
        !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading
    }

    /// Texto de acessibilidade do status atual para VoiceOver.
    var loadingAccessibilityLabel: String {
        isLoading ? "Assistente está digitando, aguarde." : ""
    }

    init(manager: FoundationsManager, coordinator: Coordinator) {
        self.manager = manager
        self.coordinator = coordinator
    }

    // MARK: - Intenções da View

    /// Chamado quando o usuário pressiona "Enviar".
    func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        inputText = ""
        Task {
            await manager.sendMessage(text)
            // Auto-dismiss do erro após 6 segundos
            if let error = manager.errorMessage {
                errorBanner = error
                try? await Task.sleep(for: .seconds(6))
                errorBanner = nil
            }
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
