//
//  LocalizationKeys.swift
//  EyeSearchTests
//
//  Created by Manoel Pedro Prado Sa Teles on 22/04/26.
//

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
        enum Card {
            enum HowToUse {
                static let title       = "hints.card.howToUse.title"
                static let description = "hints.card.howToUse.description"
            }
            enum ManageEmotions {
                static let title       = "hints.card.manageEmotions.title"
                static let description = "hints.card.manageEmotions.description"
            }
            enum FocusTips {
                static let title       = "hints.card.focusTips.title"
                static let description = "hints.card.focusTips.description"
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
            static let searchInformation = "searchObject.screen.searchInformation"
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
