//
//  ChatViewModel.swift
//  Challenge13
//
//  Created by Daniela Valadares on 16/04/26.
//

import Foundation

// MARK: - ViewModel
/// # ViewModel - ChatViewModel
/// Intermediário entre ``ChatView`` e ``FoundationsManaging``.
/// Recebe intenções da view, delega ao manager e expõe estado reativo pronto para exibição.
/// ## Usado em:
/// - ``ChatView``
@MainActor
@Observable
final class ChatViewModel {

    // MARK: - Estado publicado para a View

    /// Lista de mensagens exibidas na interface, em ordem cronológica.
    private(set) var displayedMessages: [ChatMessage] = []
    /// Texto atual do campo de entrada do usuário.
    var inputText: String = ""
    /// Indica se o assistente está processando uma resposta.
    private(set) var isLoading: Bool = false
    /// Mensagem de erro exibida no banner, ou `nil` se não houver erro ativo.
    private(set) var errorBanner: String? = nil
    /// Controla a exibição do diálogo de confirmação de limpeza do histórico.
    private(set) var showClearConfirmation: Bool = false

    // MARK: - Dependências

    /// Manager responsável pela comunicação com o modelo de linguagem.
    private let manager: any FoundationsManaging

    // MARK: - Computed

    /// Indica se o botão de envio deve estar habilitado.
    var canSend: Bool {
        !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading
    }

    /// Texto de acessibilidade do status atual para VoiceOver.
    var loadingAccessibilityLabel: String {
        isLoading ? "Assistente está digitando, aguarde." : ""
    }

    // MARK: - Init

    /// Init padrão: cria o ``FoundationsManager`` internamente.
    /// Usado pelo `@StateObject` na ``ChatView``.
    init() {
        self.manager = FoundationsManager.shared
    }

    /// Init com injeção de dependência — útil para testes e previews.
    /// - Parameters:
    ///   - manager: Qualquer tipo que conforme com ``FoundationsManaging``.
    init(manager: FoundationsManaging) {
        self.manager = manager
    }


    // MARK: - Intenções da View

    /// Lê o `inputText`, limpa o campo e delega o envio ao ``FoundationsManaging``.
    /// Não executa se o texto estiver vazio.
    func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        inputText = ""
        
        isLoading = true
        Task {
            self.displayedMessages.append(ChatMessage(role: .user, text: text))
            guard let message = try await manager.sendMessage(text) else {
                isLoading = false
                return
            }
            self.displayedMessages.append(message)
            isLoading = false
        }
    }

    /// Aciona ``sendMessage()`` somente se ``canSend`` for `true`.
    /// Chamado pelo `.onSubmit` do campo de texto.
    func handleSubmit() {
        guard canSend else { return }
        sendMessage()
    }

    /// Exibe o diálogo de confirmação de limpeza do histórico.
    func requestClear() {
        showClearConfirmation = true
    }

    /// Confirma a limpeza, delegando ao manager e fechando o diálogo.
    func confirmClear() {
        manager.clearConversation()
        showClearConfirmation = false
    }

    // MARK: - Helpers de apresentação

    /// Gera o rótulo de acessibilidade completo de uma mensagem para o VoiceOver.
    /// - Parameter message: Mensagem a ser descrita.
    /// - Returns: Texto composto pelo papel do remetente, conteúdo e flag de filtro, se aplicável.
    func accessibilityLabel(for message: ChatMessage) -> String {
        let role = message.role == .user ? "Você disse" : "Assistente respondeu"
        let filtered = message.isFiltered ? " (mensagem fora do escopo)" : ""
        return "\(role): \(message.text)\(filtered)"
    }

    /// Limpa o histórico ao sair da tela, garantindo que a conversa não persiste entre sessões.
    /// Chamado pelo `.onDisappear` da ``ChatView``.
    func onViewDisappear() {
        manager.clearConversation()
    }
}
