//
//  ChatMessage.swift
//  Challenge13
//
//  Created by Daniela Valadares on 16/04/26.
//

import Foundation

// MARK: - Model
/// # Model - ChatMessage
/// Modelo de dados que estrutura a mensagem do chatbot
/// possui id, role (enum), conteúdo (text), timestamp (quando foi gerada) e um filtro.
/// usa `Identifiable` para permitir o uso de ID
/// ## Usado em:
/// - ``FoundationsManager``
struct ChatMessage: Identifiable {
    /// Identificador único da mensagem.
    let id: UUID
    /// Quem enviou a mensagem (usuário, assistente ou sistema).
    let role: MessageRole
    /// Conteúdo textual da mensagem.
    let text: String
    /// Data e hora em que a mensagem foi criada.
    let timestamp: Date
    /// Indica se a mensagem foi filtrada por estar fora do escopo.
    var isFiltered: Bool

    /// Tipos de remetente possíveis para uma mensagem.
    enum MessageRole {
        /// Mensagem enviada pelo usuário.
        case user
        /// Resposta gerada pelo assistente.
        case assistant
        /// Mensagem do sistema (interna).
        case system
    }

    init(role: MessageRole, text: String, isFiltered: Bool = false) {
        self.id = UUID()
        self.role = role
        self.text = text
        self.timestamp = Date()
        self.isFiltered = isFiltered
    }
}
