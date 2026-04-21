//
//  FoundationManaging.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 20/04/26.
//

import Foundation

// MARK: - Protocol
/// # Protocol - FoundationsManaging
/// Interface para o chatbot de acessibilidade visual, utilizando `FoundationModels`.
/// Gerencia envio de mensagens e controle de conversas.
/// ## Implementado por:
/// - ``FoundationsManager``
protocol FoundationsManaging {
    /// Método assíncrono que envia uma mensagem do usuário ao chatbot e aguarda a resposta.
    /// - Parameter userInput: Texto digitado pelo usuário.
    func sendMessage(_ userInput: String) async
    /// Limpa o histórico de mensagens e reinicia a sessão do modelo.
    func clearConversation()
}
