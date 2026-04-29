//
//  ChatViewModel.swift
//  Challenge13
//
//  Created by Daniela Valadares on 16/04/26.
//

import Foundation
import Combine

// MARK: - ViewModel
/// # ViewModel - ChatViewModel
/// Intermediário entre ``ChatView`` e ``FoundationsManaging``.
/// Recebe intenções da view, delega ao manager e expõe estado reativo pronto para exibição.
/// ## Usado em:
/// - ``ChatView``
@MainActor
final class ChatViewModel: ObservableObject {

    // MARK: - Estado publicado para a View

    /// Lista de mensagens exibidas na interface, em ordem cronológica.
    @Published var displayedMessages: [ChatMessage] = []
    /// Texto atual do campo de entrada do usuário.
    @Published var inputText: String = ""
    /// Indica se o assistente está processando uma resposta.
    @Published var isLoading: Bool = false
    /// Mensagem de erro exibida no banner, ou `nil` se não houver erro ativo.
    @Published var errorBanner: String? = nil
    /// Controla a exibição do diálogo de confirmação de limpeza do histórico.
    @Published var showClearConfirmation: Bool = false

    // MARK: - Dependências

    /// Manager responsável pela comunicação com o modelo de linguagem.
    private let manager: any FoundationsManaging
    /// Conjunto de subscriptions Combine ativas.
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Computed

    /// Indica se o botão de envio deve estar habilitado.
    var canSend: Bool {
        !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !isLoading
    }

    /// Texto de acessibilidade do status atual para VoiceOver.
    var loadingAccessibilityLabel: String {
        isLoading ? .localized(L10n.Chat.Accessibility.loading) : ""
    }

    // MARK: - Init

    /// Init padrão: cria o ``FoundationsManager`` internamente.
    /// Usado pelo `@StateObject` na ``ChatView``.
    /// - Parameter coordinator: Instância do coordinator responsável pela navegação.
    init() {
        self.manager = FoundationsManager()
        bindManager()
    }

    /// Init com injeção de dependência — útil para testes e previews.
    /// - Parameters:
    ///   - manager: Qualquer tipo que conforme com ``FoundationsManaging``.
    ///   - coordinator: Instância do coordinator responsável pela navegação.
    init(manager: any FoundationsManaging) {
        self.manager = manager
        bindManager()
    }

    // MARK: - Binding com o Manager

    /// Assina os publishers do ``FoundationsManaging`` e repassa os valores para as propriedades `@Published`.
    /// O erro é auto-descartado após 4 segundos via `Task`.
    private func bindManager() {
        manager.messagesPublisher
            .receive(on: RunLoop.main)
            .assign(to: &$displayedMessages)

        manager.isLoadingPublisher
            .receive(on: RunLoop.main)
            .assign(to: &$isLoading)

        manager.errorMessagePublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.errorBanner = error
                // Auto-dismiss após 4 segundos
                if error != nil {
                    Task { @MainActor in
                        try? await Task.sleep(for: .seconds(4))
                        self?.errorBanner = nil
                    }
                }
            }
            .store(in: &cancellables)
    }

    // MARK: - Intenções da View

    /// Lê o `inputText`, limpa o campo e delega o envio ao ``FoundationsManaging``.
    /// Não executa se o texto estiver vazio.
    func sendMessage() {
        let text = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        inputText = ""
        Task {
            await manager.sendMessage(text)
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
        let role: String = message.role == .user
            ? .localized(L10n.Chat.Accessibility.userSaid)
            : .localized(L10n.Chat.Accessibility.assistantSaid)
        let filtered: String = message.isFiltered ? .localized(L10n.Chat.Accessibility.filteredSuffix) : ""
        return "\(role): \(message.text)\(filtered)"
    }

    /// Limpa o histórico ao sair da tela, garantindo que a conversa não persiste entre sessões.
    /// Chamado pelo `.onDisappear` da ``ChatView``.
    func onViewDisappear() {
        manager.clearConversation()
    }
}
