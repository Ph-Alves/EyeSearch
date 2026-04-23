//
//  ChatView.swift
//  Challenge13
//
//  Created by Daniela Valadares on 09/04/26.
//

import SwiftUI

// MARK: - View
/// # View - ChatView
/// Tela do chatbot de acessibilidade visual.
/// Permite ao usuário conversar com o assistente inteligente sobre dúvidas de acessibilidade.
/// ## Usado em:
/// - ``Coordinator/destination(for:)``
struct ChatView: View {

    @Environment(Coordinator.self) private var coordinator
    @StateObject private var viewModel: ChatViewModel
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    @AccessibilityFocusState private var focusOnLastMessage: Bool

    /// Inicializa a view injetando o ``Coordinator`` na ``ChatViewModel``.
    /// - Parameter coordinator: Instância do coordinator responsável pela navegação.
    init(coordinator: Coordinator) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(coordinator: coordinator))
    }

    var body: some View {
        ZStack(alignment: .top) {
            background

            VStack(spacing: 0) {
                // Banner de erro
                if let error = viewModel.errorBanner {
                    ErrorBannerView(message: error)
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .zIndex(1)
                }

                // Lista de mensagens
                messageList

                Divider()

                // Campo de entrada
                inputBar
            }
        }
        .navigationTitle("Assistente Visual")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar { toolbarContent }
        .confirmationDialog(
            "Limpar conversa?",
            isPresented: $viewModel.showClearConfirmation,
            titleVisibility: .visible
        ) {
            Button("Limpar", role: .destructive) { viewModel.confirmClear() }
            Button("Cancelar", role: .cancel) { }
        } message: {
            Text("Todo o histórico será apagado.")
        }
        .animation(.easeInOut(duration: 0.25), value: viewModel.errorBanner)
        .onDisappear {
            viewModel.onViewDisappear()
        }
    }

    /// Fundo sólido que preenche toda a área segura da tela.
    private var background: some View {
        Color(.systemGroupedBackground)
            .ignoresSafeArea()
    }

    /// Lista rolável de mensagens com scroll automático para a última mensagem ou indicador de digitação.
    private var messageList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    if viewModel.displayedMessages.isEmpty {
                        emptyState
                    } else {
                        ForEach(viewModel.displayedMessages) { message in
                            MessageBubbleView(message: message)
                                .accessibilityLabel(viewModel.accessibilityLabel(for: message))
                                .id(message.id)
                        }
                    }

                    // Indicador de digitação
                    if viewModel.isLoading {
                        TypingIndicatorView()
                            .accessibilityLabel(viewModel.loadingAccessibilityLabel)
                            .id("typing")
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .onChange(of: viewModel.displayedMessages.count) { _, _ in
                scrollToBottom(proxy: proxy)
            }
            .onChange(of: viewModel.isLoading) { _, loading in
                if loading { scrollToBottom(proxy: proxy, anchor: "typing") }
            }
        }
    }

    /// Rola a lista de mensagens até o final de forma animada.
    /// - Parameters:
    ///   - proxy: Proxy do `ScrollViewReader` usado para controlar o scroll.
    ///   - anchor: ID do elemento alvo. Se `nil`, rola até a última mensagem.
    private func scrollToBottom(proxy: ScrollViewProxy, anchor: String? = nil) {
        withAnimation(.easeOut(duration: 0.3)) {
            if let anchor {
                proxy.scrollTo(anchor, anchor: .bottom)
            } else if let last = viewModel.displayedMessages.last {
                proxy.scrollTo(last.id, anchor: .bottom)
            }
        }
    }

    // MARK: - Estado vazio

    /// Tela exibida quando não há mensagens, com ícone, descrição e sugestões de perguntas rápidas.
    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer(minLength: 60)

            Image(systemName: "eye.circle.fill")
                .font(.system(size: 64))
                .foregroundStyle(.tint)
                .accessibilityHidden(true)

            VStack(spacing: 8) {
                Text("Olá! Sou o assistente do VisionAssist.")
                    .font(.title3.weight(.semibold))
                    .multilineTextAlignment(.center)

                Text("Posso ajudar com dúvidas sobre baixa visão, acessibilidade no iPhone e as funcionalidades do app.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)

            // Sugestões rápidas
            VStack(spacing: 10) {
                ForEach(quickSuggestions, id: \.self) { suggestion in
                    SuggestionChipView(text: suggestion) {
                        viewModel.inputText = suggestion
                        viewModel.sendMessage()
                    }
                }
            }
            .padding(.horizontal, 16)

            Spacer(minLength: 40)
        }
        .frame(maxWidth: .infinity)
    }

    /// Perguntas pré-definidas exibidas no estado vazio para facilitar o início da conversa.
    private let quickSuggestions = [
        "Como ativar o VoiceOver?",
        "Quais fontes são melhores para baixa visão?",
        "Como aumentar o contraste da tela?"
    ]

    // MARK: - Barra de input

    /// Barra inferior com campo de texto multilinha e botão de envio.
    private var inputBar: some View {
        HStack(alignment: .bottom, spacing: 10) {
            // Campo de texto
            TextField(
                "Pergunte sobre acessibilidade visual...",
                text: $viewModel.inputText,
                axis: .vertical
            )
            .lineLimit(1...5)
            .textFieldStyle(.plain)
            .font(.body)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .strokeBorder(Color(.separator), lineWidth: 0.5)
                    )
            )
            .accessibilityLabel("Campo de mensagem")
            .accessibilityHint("Digite sua dúvida sobre baixa visão ou acessibilidade")
            .onSubmit { viewModel.handleSubmit() }

            // Botão enviar
            Button(action: viewModel.sendMessage) {
                ZStack {
                    Circle()
                        .fill(viewModel.canSend ? Color.accentColor : Color(.tertiarySystemFill))
                        .frame(width: 44, height: 44)

                    Image(systemName: "arrow.up")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(viewModel.canSend ? .white : .secondary)
                }
            }
            .disabled(!viewModel.canSend)
            .accessibilityLabel("Enviar mensagem")
            .accessibilityHint(viewModel.canSend ? "Toque duas vezes para enviar" : "Digite uma mensagem para habilitar")
            .animation(.easeInOut(duration: 0.2), value: viewModel.canSend)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemGroupedBackground))
    }

    // MARK: - Toolbar

    /// Toolbar com atalhos de navegação para configurações e limpeza do histórico.
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
            Button(action: viewModel.navigateToSettings) {
                Image(systemName: "gearshape")
                    .accessibilityLabel("Configurações")
            }

            Button(action: viewModel.requestClear) {
                Image(systemName: "trash")
                    .accessibilityLabel("Limpar conversa")
            }
            .disabled(viewModel.displayedMessages.isEmpty)
        }
    }
}

// MARK: - MessageBubbleView
/// # View - MessageBubbleView
/// Balão de mensagem individual exibido na lista do chat.
/// Adapta visual e alinhamento conforme o papel do remetente (usuário ou assistente).
/// Mensagens do assistente renderizam Markdown nativo via `AttributedString`.
/// Mensagens filtradas pelo escopo são destacadas com borda laranja e ícone de aviso.
/// ## Usado em:
/// - ``ChatView``
struct MessageBubbleView: View {

    /// Mensagem a ser exibida no balão.
    let message: ChatMessage

    @Environment(\.colorScheme) private var colorScheme

    private var isUser: Bool { message.role == .user }

    /// Converte o texto Markdown da mensagem em `AttributedString` para renderização nativa.
    /// Utilizado apenas nas mensagens do assistente. Em caso de falha na conversão, retorna o texto puro.
    private var formattedText: AttributedString {
        (try? AttributedString(markdown: message.text)) ?? AttributedString(message.text)
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 6) {
            if isUser { Spacer(minLength: 50) }

            // Ícone do assistente
            if !isUser {
                Image(systemName: "eye.circle.fill")
                    .font(.title3)
                    .foregroundStyle(.tint)
                    .accessibilityHidden(true)
            }

            VStack(alignment: isUser ? .trailing : .leading, spacing: 4) {
                // Balão — mensagens do usuário usam Text simples; do assistente renderizam Markdown
                Group {
                    if isUser {
                        Text(message.text)
                    } else {
                        Text(formattedText)
                    }
                }
                .font(.body)
                .foregroundStyle(isUser ? .white : .primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(bubbleBackground)
                .clipShape(bubbleShape)
                // Borda extra para mensagens filtradas (fora do escopo)
                .overlay(
                    bubbleShape
                        .strokeBorder(
                            message.isFiltered ? Color.orange.opacity(0.6) : .clear,
                            lineWidth: 1.5
                        )
                )

                // Flag de filtrado
                if message.isFiltered {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.caption2)
                        .foregroundStyle(.orange)
                        .accessibilityHidden(true)
                }
            }

            if !isUser { Spacer(minLength: 50) }
        }
        .accessibilityElement(children: .ignore)
    }

    @ViewBuilder
    private var bubbleBackground: some View {
        if isUser {
            Color.accentColor
        } else if message.isFiltered {
            Color(.secondarySystemGroupedBackground)
        } else {
            Color(.secondarySystemGroupedBackground)
        }
    }

    private var bubbleShape: some InsettableShape {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
    }
}

// MARK: - TypingIndicatorView
/// # View - TypingIndicatorView
/// Indicador animado exibido enquanto o assistente está processando uma resposta.
/// Apresenta três pontos com animação sequencial de escala.
/// ## Usado em:
/// - ``ChatView``
struct TypingIndicatorView: View {

    @State private var phase: Int = 0

    var body: some View {
        HStack(alignment: .bottom, spacing: 6) {
            Image(systemName: "eye.circle.fill")
                .font(.title3)
                .foregroundStyle(.tint)
                .accessibilityHidden(true)

            HStack(spacing: 5) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color(.tertiaryLabel))
                        .frame(width: 8, height: 8)
                        .scaleEffect(phase == index ? 1.4 : 1.0)
                        .animation(
                            .easeInOut(duration: 0.4)
                                .repeatForever()
                                .delay(Double(index) * 0.15),
                            value: phase
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color(.secondarySystemGroupedBackground))
            )

            Spacer(minLength: 50)
        }
        .onAppear {
            withAnimation { phase = 0 }
        }
    }
}

// MARK: - SuggestionChipView
/// # View - SuggestionChipView
/// Botão de sugestão rápida exibido no estado vazio do chat.
/// Ao ser tocado, preenche o campo de texto e envia a mensagem automaticamente.
/// ## Usado em:
/// - ``ChatView``
struct SuggestionChipView: View {

    /// Texto da sugestão exibido no botão.
    let text: String
    /// Ação executada ao tocar no chip.
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(text)
                .font(.subheadline)
                .foregroundStyle(.tint)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.accentColor.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .strokeBorder(Color.accentColor.opacity(0.25), lineWidth: 1)
                        )
                )
        }
        .accessibilityLabel("Sugestão: \(text). Toque duas vezes para enviar.")
    }
}

// MARK: - ErrorBannerView
/// # View - ErrorBannerView
/// Banner vermelho exibido no topo da tela quando ocorre um erro no chatbot.
/// Desaparece automaticamente após 4 segundos, controlado pela ``ChatViewModel``.
/// ## Usado em:
/// - ``ChatView``
struct ErrorBannerView: View {

    /// Texto do erro a ser exibido no banner.
    let message: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundStyle(.white)
                .accessibilityHidden(true)

            Text(message)
                .font(.footnote.weight(.medium))
                .foregroundStyle(.white)
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.red.gradient)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Erro: \(message)")
    }
}

// MARK: - Preview

#Preview {
    let coordinator = Coordinator(dependencyContainer: DependencyContainer())
    CoordinatedNavigationStack {
        ChatView(coordinator: coordinator)
    }
    .environment(coordinator)
}
