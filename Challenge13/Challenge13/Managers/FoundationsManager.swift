//
//  FoundationsManager.swift
//  Challenge13
//
//  Created by Daniela Valadares on 15/04/26.
//

import Foundation
import FoundationModels

// MARK: - Manager
/// # Manager - FoundationsManager
/// Gerencia o chatbot de acessibilidade visual utilizando `FoundationModels` (Apple Intelligence).
/// Filtra mensagens fora do escopo e mantém o histórico da conversa.
/// ## Usado em:
/// - ``ChatView`` (via ViewModel)
final class FoundationsManager: FoundationsManaging {
    // MARK: - Errors
    /// Erros internos do chatbot, mapeados para mensagens amigáveis ao usuário.
    private enum ChatbotError: LocalizedError {
        /// A pergunta está fora do escopo do assistente.
        case offTopic
        /// O Apple Intelligence não está disponível no dispositivo.
        case modelUnavailable
        /// O modelo retornou uma resposta vazia.
        case emptyResponse
        /// A sessão do modelo falhou com um motivo específico.
        case sessionFailed(String)

        var errorDescription: String? {
            switch self {
            case .offTopic:
                return "Só posso ajudar com temas relacionados a baixa visão, acessibilidade visual e funcionalidades do app."
            case .modelUnavailable:
                return "O assistente não está disponível no momento. Verifique se o Apple Intelligence está ativado nas configurações."
            case .emptyResponse:
                return "Não consegui gerar uma resposta. Tente reformular sua pergunta."
            case .sessionFailed(let reason):
                return "Falha na sessão: \(reason)"
            }
        }
    }
    
    // MARK: - Variables
    /// Singleton
    static let shared: FoundationsManaging = FoundationsManager()
    /// Sessão do modelo de linguagem Apple Intelligence.
    private var session: LanguageModelSession?

    // MARK: - FoundationsManaging

    /// Instruções de sistema enviadas ao modelo na inicialização da sessão.
    /// Define identidade, escopo, restrições e estilo de resposta do assistente.
    private let systemPrompt = """
    Você é o assistente virtual do app de acessibilidade visual "EyeSearch".

    SEU PROPÓSITO:
    Ajudar exclusivamente pessoas com baixa visão ou deficiência visual a:
    - Usar e navegar as funcionalidades do app EyeSearch
    - Entender recursos de acessibilidade do iPhone/iPad (VoiceOver, Zoom, Lupa, DetecçãoDePessoas, etc.)
    - Descobrir dicas, atalhos e configurações de acessibilidade visual no iOS
    - Encontrar recursos e orientações para pessoas com deficiência visual

    EXEMPLOS DE PERGUNTAS QUE VOCÊ DEVE RESPONDER:
    - "Como ativo o VoiceOver?"
    - "Quais fontes são mais fáceis de ler para quem tem baixa visão?"
    - "O que é retinopatia diabética?"
    - "Quais configurações de contraste o app oferece?"

    RESTRIÇÕES — NUNCA faça o seguinte:
    - Não responda perguntas completamente fora do tema de baixa visão e acessibilidade visual
    - Não gere código de programação
    - Não discuta política, esportes, entretenimento, finanças ou outros tópicos não relacionados
    - Não forneça diagnósticos médicos; em caso de dúvidas de saúde, oriente a consultar um oftalmologista
    - Não responda a situações hipotéticas fora do propósito

    ESTILO DE RESPOSTA:
    - Seja claro, empático e acolhedor
    - Use frases curtas e diretas (facilita leitores de tela)
    - Evite jargões técnicos desnecessários
    - Quando mencionar passos, use numeração simples (1., 2., 3.)
    - Máximo de 250 palavras por resposta
    """

    /// Palavras-chave do domínio do app usadas na validação local de escopo.
    /// Mensagens longas sem nenhuma dessas palavras são delegadas ao modelo para decisão.
    private let inScopeKeywords: [String] = [
        // Baixa visão e condições
        "visão", "visual", "olho", "olhos", "oftalmol", "catarata", "glaucoma",
        "retina", "retinopatia", "macular", "miopia", "hipermetropia", "astigmatismo",
        "cegueira", "deficiência visual", "baixa visão", "daltonismo", "nistagmo",

        // Acessibilidade iOS
        "voiceover", "zoom", "lupa", "contraste", "acessibilidade", "fonte",
        "tamanho de texto", "brilho", "leitor de tela", "talkback", "siri",
        "aumentar", "ampliar", "magnificar", "cursor", "foco", "descrição por voz",
        "leitura", "alto contraste", "modo escuro",

        // App
        "app", "aplicativo", "visionassist", "funcionalidade", "recurso",
        "configuração", "tela", "botão", "navegar", "menu",

        // Ajuda e orientação
        "como usar", "como ativar", "ajuda", "suporte", "dica", "passo",
        "tutorial", "guia", "orientação", "recurso", "serviço"
    ]

    // MARK: - Init
    /// Inicializa o manager e configura a sessão do modelo de linguagem.
    private init() {
        setupSession()
    }

    // MARK: - Functions
    /// Envia uma mensagem ao chatbot, faz validação local de escopo e processa a resposta do modelo.
    /// - Parameter userInput: Texto digitado pelo usuário.
    func sendMessage(_ userInput: String) async -> ChatMessage? {
        let trimmed = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        do {
            // Verifica localmente se a mensagem está fora do escopo antes de enviar ao modelo
            if let localDenial = localScopeCheck(for: trimmed) {
                return ChatMessage(role: .assistant, text: localDenial, isFiltered: true)
            }

            // Garante que a sessão do modelo está disponível
            guard let session else { throw ChatbotError.modelUnavailable }
            
            // Envia a mensagem ao modelo e aguarda a resposta
            let response = try await session.respond(to: trimmed)

            // Limpa e valida a resposta do modelo
            let rawText = response.content.trimmingCharacters(in: .whitespacesAndNewlines)
            let finalText = try processModelResponse(rawText)

            return ChatMessage(role: .assistant, text: finalText)
            

        } catch let error as ChatbotError {
            // Trata erros específicos do chatbot (off-topic, modelo indisponível, etc.)
            return ChatMessage(
                role: .assistant,
                text: error.errorDescription ?? "Erro desconhecido.",
                isFiltered: true
            )
        } catch {
            // Trata erros genéricos da sessão (ex: session.respond lança erro não tipado)
            let chatError = ChatbotError.sessionFailed(error.localizedDescription)
            return ChatMessage(
                role: .assistant,
                text: chatError.errorDescription ?? "Erro desconhecido.",
                isFiltered: true
            )
        }
    }

    /// Limpa o histórico de mensagens e reinicia a sessão do modelo.
    func clearConversation() {
        setupSession()
    }
    
    // MARK: - Helpers
    /// Inicializa ou reinicia a `LanguageModelSession` com o system prompt configurado.
    /// Emite erro no ``errorMessagePublisher`` se o Apple Intelligence não estiver disponível.
    private func setupSession() {
        guard SystemLanguageModel.default.isAvailable else {
            return
        }

        session = LanguageModelSession(
            model: .default,
            instructions: systemPrompt
        )
    }

    /// Verifica localmente se a mensagem do usuário está dentro do escopo do chatbot.
    /// Mensagens com até 3 palavras passam direto. Mensagens maiores são validadas contra ``inScopeKeywords``.
    /// - Parameter input: Texto digitado pelo usuário.
    /// - Returns: Mensagem de negação se fora do escopo, ou `nil` para deixar o modelo decidir.
    private func localScopeCheck(for input: String) -> String? {
        let lower = input.lowercased()

//        // Se contém palavras explicitamente fora do escopo, rejeita imediatamente
//        for keyword in outOfScopeKeywords {
//            if lower.contains(keyword) {
//                return scopeDenialMessage()
//            }
//        }

        // Mensagens curtas (até 3 palavras) passam direto — podem ser saudações ou comandos simples
        if input.split(separator: " ").count <= 3 {
            return nil
        }

        // Para mensagens maiores, verifica se contém pelo menos uma palavra do escopo
        let hasInScopeWord = inScopeKeywords.contains { lower.contains($0) }
        if !hasInScopeWord {
            return nil
        }

        return nil
    }

    /// Processa e sanitiza a resposta bruta do modelo.
    /// Detecta o marcador `FORA_DO_ESCOPO` e remove linhas vazias e espaços extras.
    /// - Parameter raw: Texto bruto retornado pelo modelo.
    /// - Returns: Texto final pronto para exibição.
    /// - Throws: ``ChatbotError/emptyResponse`` se a resposta estiver vazia.
    private func processModelResponse(_ raw: String) throws -> String {
        guard !raw.isEmpty else { throw ChatbotError.emptyResponse }

        // O modelo pode retornar "FORA_DO_ESCOPO" como sinal de que a pergunta não é do tema
        if raw.contains("FORA_DO_ESCOPO") {
            return scopeDenialMessage()
        }

        // Preserva quebras de parágrafo para renderização correta do Markdown via AttributedString.
        // AttributedString(markdown:) exige \n\n entre blocos para criar parágrafos separados.
        return raw
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .joined(separator: "\n\n")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Mensagem padrão exibida ao usuário quando a pergunta está fora do escopo do assistente.
    /// - Returns: Texto amigável orientando o usuário sobre o propósito do assistente.
    private func scopeDenialMessage() -> String {
        return """
        Desculpe, só consigo ajudar com assuntos relacionados à \
        acessibilidade visual e funcionalidades do EyeSearch. \
        Tem alguma dúvida sobre isso que eu possa responder? 👁️
        """
    }
}
