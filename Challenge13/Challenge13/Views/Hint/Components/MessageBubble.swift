//
//  MessageBubble.swift
//  EyeSearch
//
//  Created by Paulo Henrique Costa Alves on 28/04/26.
//

import SwiftUI

// MARK: - Component
/// # Component - MessageBubble
/// Bolha de mensagem do chat, que varia com base se é um usuário o chat enviando a mensagem
/// ## Usado em:
/// - ``ChatView``
struct MessageBubble: View {
    // MARK: - Variables
    
    /// Chat message - ``ChatMessage``
    var message: ChatMessage
    
    /// Inicializador para impedir o private padrão
    init(message: ChatMessage) {
        self.message = message
    }
    
    /// Computed property que verifica a mensagem assim que é usada
    private var isUser: Bool { message.role == .user }
    
    // View values
    private var imageWidth: CGFloat = 10
    private var imageHeight: CGFloat = 10
    private var textPadding: CGFloat = 12
    private var backgroundOpacity: Double = 0.5
    private var textBackgroundRadius: CGFloat = 16

    // MARK: - Body View
    var body: some View {
        HStack(alignment: .bottom) {
            if isUser {
                Spacer()
            } else {
                Image(systemName: "eye.fill")
                    .frame(width: imageWidth, height: imageHeight)
                    .padding()
                    .background(Color.hintsPrimary)
                    .clipShape(Circle())
            }

            Text(message.text)
                .padding(textPadding)
                .background(isUser ? .hintsPrimary : .gray.opacity(backgroundOpacity))
                .foregroundStyle(Color.primary)
                .clipShape(RoundedRectangle(cornerRadius: textBackgroundRadius))

            if !isUser { Spacer() }
        }
        .padding(.horizontal)
    }
}

// MARK: - Preview
#Preview {
    VStack {
        MessageBubble(message: ChatMessage(role: .assistant, text: "Olá! Como posso ajudar?"))
        MessageBubble(message: ChatMessage(role: .user, text: "Quero uma dica"))
    }
}
