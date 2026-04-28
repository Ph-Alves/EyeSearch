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
        enum Haptics {
            static let title       = "settings.haptics.title"
            static let description = "settings.haptics.description"
        }
        enum Sound {
            static let title       = "settings.sound.title"
            static let description = "settings.sound.description"
        }
        enum Onboarding {
            static let button = "settings.onboarding.button"
            static let footer = "settings.onboarding.footer"
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

    // MARK: - YOLO Labels
    enum YOLO {
        enum Label {
            static let aeroplane     = "yolo.label.aeroplane"
            static let apple         = "yolo.label.apple"
            static let backpack      = "yolo.label.backpack"
            static let banana        = "yolo.label.banana"
            static let baseballbat   = "yolo.label.baseballbat"
            static let baseballglove = "yolo.label.baseballglove"
            static let bear          = "yolo.label.bear"
            static let bed           = "yolo.label.bed"
            static let bench         = "yolo.label.bench"
            static let bird          = "yolo.label.bird"
            static let boat          = "yolo.label.boat"
            static let book          = "yolo.label.book"
            static let bottle        = "yolo.label.bottle"
            static let bowl          = "yolo.label.bowl"
            static let broccoli      = "yolo.label.broccoli"
            static let bus           = "yolo.label.bus"
            static let cake          = "yolo.label.cake"
            static let car           = "yolo.label.car"
            static let carrot        = "yolo.label.carrot"
            static let cat           = "yolo.label.cat"
            static let cellphone     = "yolo.label.cellphone"
            static let chair         = "yolo.label.chair"
            static let cow           = "yolo.label.cow"
            static let cup           = "yolo.label.cup"
            static let diningtable   = "yolo.label.diningtable"
            static let dog           = "yolo.label.dog"
            static let donut         = "yolo.label.donut"
            static let elephant      = "yolo.label.elephant"
            static let firehydrant   = "yolo.label.firehydrant"
            static let fork          = "yolo.label.fork"
            static let frisbee       = "yolo.label.frisbee"
            static let giraffe       = "yolo.label.giraffe"
            static let hairdrier     = "yolo.label.hairdrier"
            static let handbag       = "yolo.label.handbag"
            static let horse         = "yolo.label.horse"
            static let hotdog        = "yolo.label.hotdog"
            static let keyboard      = "yolo.label.keyboard"
            static let kite          = "yolo.label.kite"
            static let knife         = "yolo.label.knife"
            static let laptop        = "yolo.label.laptop"
            static let microwave     = "yolo.label.microwave"
            static let motorbike     = "yolo.label.motorbike"
            static let mouse         = "yolo.label.mouse"
            static let orange        = "yolo.label.orange"
            static let oven          = "yolo.label.oven"
            static let parkingmeter  = "yolo.label.parkingmeter"
            static let person        = "yolo.label.person"
            static let pizza         = "yolo.label.pizza"
            static let pottedplant   = "yolo.label.pottedplant"
            static let refrigerator  = "yolo.label.refrigerator"
            static let remote        = "yolo.label.remote"
            static let sandwitch     = "yolo.label.sandwitch"
            static let scissors      = "yolo.label.scissors"
            static let sheep         = "yolo.label.sheep"
            static let sink          = "yolo.label.sink"
            static let skateboard    = "yolo.label.skateboard"
            static let skis          = "yolo.label.skis"
            static let snowboard     = "yolo.label.snowboard"
            static let sofa          = "yolo.label.sofa"
            static let spoon         = "yolo.label.spoon"
            static let sportsball    = "yolo.label.sportsball"
            static let stopsign      = "yolo.label.stopsign"
            static let suitcase      = "yolo.label.suitcase"
            static let surfboard     = "yolo.label.surfboard"
            static let teddybear     = "yolo.label.teddybear"
            static let tennisracket  = "yolo.label.tennisracket"
            static let tie           = "yolo.label.tie"
            static let toaster       = "yolo.label.toaster"
            static let toilet        = "yolo.label.toilet"
            static let toothbrush    = "yolo.label.toothbrush"
            static let trafficlight  = "yolo.label.trafficlight"
            static let train         = "yolo.label.train"
            static let truck         = "yolo.label.truck"
            static let tvmonitor     = "yolo.label.tvmonitor"
            static let umbrella      = "yolo.label.umbrella"
            static let vase          = "yolo.label.vase"
            static let wineglass     = "yolo.label.wineglass"
            static let zebra         = "yolo.label.zebra"
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