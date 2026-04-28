//
//  LocalizationKeys.swift
//  EyeSearchTests
//
//  Created by Manoel Pedro Prado Sa Teles on 22/04/26.
//

import Foundation

// MARK: - Localization Keys
enum L10n {

    enum Common {
        enum Button {
            static let back = "common.button.back"
        }
    }

// MARK: - Views
    
    enum Home {
        enum Menu {
            static let search   = "home.menu.search"
            static let generate = "home.menu.generate"
            static let hints    = "home.menu.hints"
            static let settings = "home.menu.settings"
        }
    }

    enum Hints {
        
        enum Screen {
            static let title       = "hints.screen.title"
            static let description = "hints.screen.description"
            
            static let chatTitle       = "hints.screen.chat.title"
            static let chatDescription = "hints.screen.chat.description"
        }
        
        enum Card {
            enum Stickers {
                static let title       = "hints.card.stickers.title"
                static let description = "hints.card.stickers.description"
            
            }
            enum Siri {
                static let title       = "hints.card.siri.title"
                static let description = "hints.card.siri.description"
            }
            enum Text {
                static let title       = "hints.card.text.title"
                static let description = "hints.card.text.description"
            }
            enum VoiceOver {
                static let title       = "hints.card.voiceOver.title"
                static let description = "hints.card.voiceOver.description"
            }
            enum Widgets {
                static let title       = "hints.card.widgets.title"
                static let description = "hints.card.widgets.description"
            }
        }
    }

    enum Settings {
        enum Screen {
            static let title = "settings.screen.title"
        }
    }
    
    enum SearchObject {
        enum Screen {
            static let searchSticker = "searchObject.screen.searchSticker"
            static let stickerCount      = "searchObject.screen.stickerCount"
        }
    }

    enum Sticker {
        enum Screen {
            static let title = "sticker.screen.title"
        }
        enum Button {
            static let generatePDF = "sticker.button.generatePDF"
            static let exportPDF   = "sticker.button.exportPDF"
        }
        enum Preview {
            static let navigationTitle = "sticker.preview.navigationTitle"
        }
        enum Quantity {
            // Full key as registered in xcstrings (includes the %lld format specifier)
            static let label = "sticker.quantity.label %lld"
        }
    }
    
    //MARK: - Intents
    
    enum Intents {
        enum SearchObject {
            static let shortTitle  = "intents.searchObject.shortTitle"
            
            static let searchObejct = "intents.searchObject.title"
            static let openSearch   = "intents.searchObject.openSearch"
            static let obejctSearch  = "intents.searchObject.openSticker"
        }
    }
}

extension String {
    static func localized(_ key: String) -> String {
        NSLocalizedString(key, comment: "")
    }
    
    static func localized(_ key: String, _ args: CVarArg...) -> String {
            String(format: NSLocalizedString(key, comment: ""), arguments: args)
        }
}
