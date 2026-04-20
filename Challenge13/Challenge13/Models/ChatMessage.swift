//
//  ChatMessage.swift
//  Challenge13
//
//  Created by Daniela Valadares on 16/04/26.
//

import Foundation

struct ChatMessage: Identifiable {
    let id: UUID
    let role: MessageRole
    let text: String
    var isFiltered: Bool

    enum MessageRole {
        case user, assistant, system
    }

    init(role: MessageRole, text: String, isFiltered: Bool = false) {
        self.id = UUID()
        self.role = role
        self.text = text
        self.isFiltered = isFiltered
    }
}
