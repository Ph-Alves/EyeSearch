//
//  ChatUserText.swift
//  EyeSearch
//
//  Created by Paulo Henrique Costa Alves on 28/04/26.
//

import SwiftUI
// MARK: - Component
/// # Component - ChatUserText
/// Componente responsável por permitir o envio de mensagens
/// ## Usado em:
/// - ``ChatView``
struct ChatUserText: View {
    // MARK: - Variables
    /// Objeto viewModel que permite as operações e acesso as variáveis.
    @ObservedObject var chatVM: ChatViewModel

    // MARK: - Body View
    var body: some View {
        HStack(spacing: 8) {
            TextField(LocalizedStringKey(L10n.Chat.Input.placeholder), text: $chatVM.inputText)
                .textFieldStyle(.plain)

            Button(action: {
                chatVM.sendMessage()
            }, label: {
                Image(systemName: "arrow.up")
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
            })
            .buttonStyle(.plain)
            .padding(8)
            .background(.hintsPrimary)
            .clipShape(Circle())
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
        .padding()
    }
}

// MARK: - Preview
#Preview {
    ChatUserText(chatVM: ChatViewModel())
}
