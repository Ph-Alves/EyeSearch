//
//  L10n+Chat.swift
//  EyeSearch
//

extension L10n {
    enum Chat {
        enum Error {
            static let offTopic         = "chat.error.offTopic"
            static let modelUnavailable = "chat.error.modelUnavailable"
            static let emptyResponse    = "chat.error.emptyResponse"
            static let sessionFailed    = "chat.error.sessionFailed %@"
            static let scopeDenial      = "chat.error.scopeDenial"
        }
        enum Accessibility {
            static let loading          = "chat.accessibility.loading"
            static let userSaid         = "chat.accessibility.userSaid"
            static let assistantSaid    = "chat.accessibility.assistantSaid"
            static let filteredSuffix   = "chat.accessibility.filteredSuffix"
        }
        enum Input {
            static let placeholder      = "chat.input.placeholder"
        }
    }
}
