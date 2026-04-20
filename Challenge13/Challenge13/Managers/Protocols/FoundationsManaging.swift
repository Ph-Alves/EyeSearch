//
//  FoundationManaging.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 20/04/26.
//

import Foundation

// MARK: - Protocol para FoundationsManager
protocol FoundationsManaging {
    func sendMessage(_ userInput: String) async -> Void
    func clearConversation() -> Void
}
