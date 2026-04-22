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
    
    // MARK: - System Prompt
    
    /// Define identidade, escopo e comportamento do assistente.
    private let systemPrompt = """
    Você é o assistente virtual do app de acessibilidade visual "EyeSearch".
    
    SEU PROPÓSITO:
    Ajudar exclusivamente pessoas com baixa visão ou deficiência visual a:
    - Usar e navegar as funcionalidades do app EyeSearch
    - Entender recursos de acessibilidade do iPhone/iPad (VoiceOver, Zoom, Lupa, DetecçãoDePessoas, etc.)
    - Descobrir dicas, atalhos e configurações de acessibilidade visual no iOS
    - Encontrar recursos e orientações para pessoas com deficiência visual
    
    ESTILO DE RESPOSTA:
    - Seja claro, empático e acolhedor
    - Use frases curtas e diretas (facilita leitores de tela)
    - Evite jargões técnicos desnecessários
    - Quando mencionar passos, use numeração simples (1., 2., 3.)
    - Máximo de 250 palavras por resposta
    """
    
    /// Palavras relacionadas ao domínio do app.
    /// Usadas apenas como filtro secundário de segurança.
    private let inScopeKeywords: [String] = [
        //        // Baixa visão e condições
        //        "visão", "visual", "olho", "olhos", "oftalmol", "catarata", "glaucoma",
        //        "retina", "retinopatia", "macular", "miopia", "hipermetropia", "astigmatismo",
        //        "cegueira", "deficiência visual", "baixa visão", "daltonismo", "nistagmo",
        //
        //        // Acessibilidade iOS
        //        "voiceover", "zoom", "lupa", "contraste", "acessibilidade", "fonte",
        //        "tamanho de texto", "brilho", "leitor de tela", "talkback", "siri",
        //        "aumentar", "ampliar", "magnificar", "cursor", "foco", "descrição por voz",
        //        "leitura", "alto contraste", "modo escuro",
        //
        //        // App
        //        "app", "aplicativo", "visionassist", "funcionalidade", "recurso",
        //        "configuração", "tela", "botão", "navegar", "menu",
        //
        //        // Ajuda e orientação
        //        "como usar", "como ativar", "ajuda", "suporte", "dica", "passo",
        //        "tutorial", "guia", "orientação", "recurso", "serviço"
    ]
    
    /// Palavras que sinalizam claramente que a pergunta está fora do escopo.
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
        
        // Adiciona mensagem do usuário
        let userMessage = ChatMessage(role: .user, text: trimmed)
        messages.append(userMessage)
        isLoading = true
        errorMessage = nil
        
        // Etapa 1: filtro local rápido antes de chamar o modelo
        do {
            if let localDenial = localScopeCheck(for: trimmed) {
                let filtered = ChatMessage(role: .assistant, text: localDenial, isFiltered: true)
                messages.append(filtered)
                isLoading = false
                return
            }
            
            // Etapa 2: chama o modelo Foundation
            guard let session else { throw ChatbotError.modelUnavailable }
            let response = try await session.respond(to: "Me envie uma mensagem de oi")
            
            // Etapa 3: verifica se o modelo sinalizou fora do escopo
            let rawText = response.content.trimmingCharacters(in: .whitespacesAndNewlines)
            let finalText = try processModelResponse(rawText)
            
            let assistantMessage = ChatMessage(role: .assistant, text: finalText)
            messages.append(assistantMessage)
            
        } catch let error as ChatbotError {
            errorMessage = error.errorDescription
            let errorMsg = ChatMessage(
                role: .assistant,
                text: error.errorDescription ?? "Erro desconhecido.",
                isFiltered: true
            )
            messages.append(errorMsg)
        } catch {
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
    
    
    /// Filtro local (Etapa 1): verifica palavras-chave antes de chamar o modelo.
    /// Retorna uma mensagem de negação se fora do escopo, ou nil se parecer válido.
    // Se a mensagem for muito curta (saudação, etc.) -> deixa passar
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
        
        // Se não contém nenhuma palavra do escopo em mensagens mais longas -> deixa o modelo decidir
        // Para mensagens maiores, verifica se contém pelo menos uma palavra do escopo
        let hasInScopeWord = inScopeKeywords.contains { lower.contains($0) }
        if !hasInScopeWord {
            return nil
        }
        
        return nil
    }
    
    /// Processa a resposta do modelo (Etapa 3).
    /// Verifica o marcador FORA_DO_ESCOPO e sanitiza o conteúdo.
    /// Processa e limpa a resposta bruta do modelo, verificando se ele se recusou a responder.
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
    
    /// Mensagem padrão amigável para perguntas fora do escopo.
    private func scopeDenialMessage() -> String {
        return """
    Desculpe, só consigo ajudar com assuntos relacionados à \
    acessibilidade visual e funcionalidades do EyeSearch. \
    Tem alguma dúvida sobre isso que eu possa responder? 
    """
    }
}
