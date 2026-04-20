//
//  FoundationManaging.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 20/04/26.
//

import Foundation

protocol FoundationManaging {
    func sendMessage(_ userInput: String) async -> Void
    func clearConversation() -> Void
}
