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
    private enum ChatbotError: LocalizedError {
        case offTopic
        case modelUnavailable
        case emptyResponse
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
    // Histórico de mensagens da conversa.
    private var messages: [ChatMessage] = []
    // Indica se uma resposta está sendo processada.
    private var isLoading: Bool = false
    // Mensagem de erro atual, se houver.
    private var errorMessage: String? = nil
    // Sessão do modelo de linguagem Apple Intelligence.
    private var session: LanguageModelSession?

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
    - "Como usar o recurso de leitura de documentos do app?"
    - "Quais configurações de contraste o app oferece?"

    RESTRIÇÕES — NUNCA faça o seguinte:
    - Não responda perguntas completamente fora do tema de baixa visão e acessibilidade visual
    - Tirar dúvidas sobre baixa visão e/ou condições oculares
    - Não gere código de programação
    - Não discuta política, esportes, entretenimento, finanças ou outros tópicos não relacionados
    - Não forneça diagnósticos médicos; em caso de dúvidas de saúde, oriente a consultar um oftalmologista
    - Não responda a situações hipotéticas fora do propósito

    SE A PERGUNTA ESTIVER FORA DO ESCOPO E DO PROPÓSITO:
    Responda que você não possui tais informações

    ESTILO DE RESPOSTA:
    - Seja claro, empático e acolhedor
    - Use frases curtas e diretas (facilita leitores de tela)
    - Evite jargões técnicos desnecessários
    - Quando mencionar passos, use numeração simples (1., 2., 3.)
    - Máximo de 250 palavras por resposta
    """

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

    private let outOfScopeKeywords: [String] = [
        "futebol", "basquete", "esporte", "jogo", "placar", "campeonato",
        "receita culinária", "cozinhar", "ingrediente",
        "investimento", "ação", "bolsa de valores", "bitcoin", "criptomoeda",
        "política", "presidente", "eleição", "governo", "partido",
        "série", "filme", "novela", "netflix", "streaming",
        "música", "banda", "show", "concerto",
        "viagem", "hotel", "passagem", "destino turístico",
        "código", "programar", "python", "javascript", "html"
    ]

    // MARK: - Init
    init() {
        setupSession()
    }

    // MARK: - Functions
    /// Envia uma mensagem ao chatbot, faz validação local de escopo e processa a resposta do modelo.
    /// - Parameter userInput: Texto digitado pelo usuário.
    func sendMessage(_ userInput: String) async {
        let trimmed = userInput.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let userMessage = ChatMessage(role: .user, text: trimmed)
        messages.append(userMessage)
        isLoading = true
        errorMessage = nil

        do {
            // Verifica localmente se a mensagem está fora do escopo antes de enviar ao modelo
            if let localDenial = localScopeCheck(for: trimmed) {
                let filtered = ChatMessage(role: .assistant, text: localDenial, isFiltered: true)
                messages.append(filtered)
                isLoading = false
                return
            }

            // Garante que a sessão do modelo está disponível
            guard let session else { throw ChatbotError.modelUnavailable }
            
            // Envia a mensagem ao modelo e aguarda a resposta
            let response = try await session.respond(to: trimmed)

            // Limpa e valida a resposta do modelo
            let rawText = response.content.trimmingCharacters(in: .whitespacesAndNewlines)
            let finalText = try processModelResponse(rawText)

            let assistantMessage = ChatMessage(role: .assistant, text: finalText)
            messages.append(assistantMessage)

        } catch let error as ChatbotError {
            // Trata erros específicos do chatbot (off-topic, modelo indisponível, etc.)
            errorMessage = error.errorDescription
            let errorMsg = ChatMessage(
                role: .assistant,
                text: error.errorDescription ?? "Erro desconhecido.",
                isFiltered: true
            )
            messages.append(errorMsg)
        } catch {
            // Trata erros genéricos da sessão
            let chatError = ChatbotError.sessionFailed(error.localizedDescription)
            errorMessage = chatError.errorDescription
        }

        isLoading = false
    }

    /// Limpa o histórico de mensagens e reinicia a sessão do modelo.
    func clearConversation() {
        messages.removeAll()
        errorMessage = nil
        setupSession()
    }
    
    // MARK: - Helpers
    private func setupSession() {
        guard SystemLanguageModel.default.isAvailable else {
            errorMessage = ChatbotError.modelUnavailable.errorDescription
            return
        }

        session = LanguageModelSession(
            model: .default,
            instructions: systemPrompt
        )
    }

    // Verifica localmente se a mensagem do usuário está dentro do escopo do chatbot.
    // Retorna uma mensagem de negação se estiver fora, ou nil se estiver dentro do escopo.
    private func localScopeCheck(for input: String) -> String? {
        let lower = input.lowercased()

        // Se contém palavras explicitamente fora do escopo, rejeita imediatamente
        for keyword in outOfScopeKeywords {
            if lower.contains(keyword) {
                return scopeDenialMessage()
            }
        }

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

    // Processa e limpa a resposta bruta do modelo, verificando se ele se recusou a responder.
    private func processModelResponse(_ raw: String) throws -> String {
        guard !raw.isEmpty else { throw ChatbotError.emptyResponse }

        // O modelo pode retornar "FORA_DO_ESCOPO" como sinal de que a pergunta não é do tema
        if raw.contains("FORA_DO_ESCOPO") {
            return scopeDenialMessage()
        }

        // Remove linhas vazias e espaços extras da resposta
        return raw
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
            .joined(separator: "\n")
    }

    private func scopeDenialMessage() -> String {
        return """
        Desculpe, só consigo ajudar com assuntos relacionados à \
        acessibilidade visual e funcionalidades do EyeSearch. \
        Tem alguma dúvida sobre isso que eu possa responder? 👁️
        """
    }
}
