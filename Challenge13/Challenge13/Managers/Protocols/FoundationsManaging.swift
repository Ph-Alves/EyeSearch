//
//  FoundationManaging.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 20/04/26.
//

import Foundation
import Combine

// MARK: - Protocol
/// # Protocol - FoundationsManaging
/// Interface para o chatbot de acessibilidade visual, utilizando `FoundationModels`.
/// Gerencia envio de mensagens e controle de conversas.
/// ## Implementado por:
/// - ``FoundationsManager``
protocol FoundationsManaging {
    /// Singleton
    static var shared: FoundationsManaging { get }
    /// Publishers expostos como AnyPublisher — sem amarrar a implementação
    var messagesPublisher: AnyPublisher<[ChatMessage], Never> { get }
    var isLoadingPublisher: AnyPublisher<Bool, Never> { get }
    var errorMessagePublisher: AnyPublisher<String?, Never> { get }
    
    /// Método assíncrono que envia uma mensagem do usuário ao chatbot e aguarda a resposta.
    /// - Parameter userInput: Texto digitado pelo usuário.
    func sendMessage(_ userInput: String) async
    /// Limpa o histórico de mensagens e reinicia a sessão do modelo.
    func clearConversation()
}
