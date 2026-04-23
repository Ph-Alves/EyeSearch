//
//  YoloTranslations.swift
//  EyeSearch
//
//  Created by Paulo Henrique Costa Alves on 23/04/26.
//

import Foundation

// MARK: - Enum
/// Enum de tradução de labels do Yolo
enum YoloTranslations: String {
    case person
    case car
    case motorbike
    case aeroplane
    case bus
    case train
    case truck
    case boat
    case trafficlight
    case firehydrant
    case stopsign
    case parkingmeter
    case bench
    case bird
    case cat
    case dog
    case horse
    case sheep
    case cow
    case elephant
    case bear
    case zebra
    case giraffe
    case backpack
    case umbrella
    case handbag
    case tie
    case suitcase
    case frisbee
    case skis
    case snowboard
    case sportsball
    case kite
    case baseballbat
    case baseballglove
    case skateboard
    case surfboard
    case tennisracket
    case bottle
    case wineglass
    case cup
    case fork
    case knife
    case spoon
    case bowl
    case banana
    case apple
    case sandwitch
    case orange
    case broccoli
    case carrot
    case hotdog
    case pizza
    case donut
    case cake
    case chair
    case sofa
    case pottedplant
    case bed
    case diningtable
    case toilet
    case tvmonitor
    case laptop
    case mouse
    case remote
    case keyboard
    case cellphone
    case microwave
    case oven
    case toaster
    case sink
    case refrigerator
    case book
    case vase
    case scissors
    case teddybear
    case hairdrier
    case toothbrush

    var localizedString: String {
        switch self {
        case .person: return String(localized: "Pessoa")
        case .car: return String(localized: "Carro")
        case .motorbike: return String(localized: "Motocicleta")
        case .aeroplane: return String(localized: "Avião")
        case .bus: return String(localized: "Ônibus")
        case .train: return String(localized: "Trem")
        case .truck: return String(localized: "Caminhão")
        case .boat: return String(localized: "Barco")
        case .trafficlight: return String(localized: "Semáforo")
        case .firehydrant: return String(localized: "Hidrante")
        case .stopsign: return String(localized: "Placa de Pare")
        case .parkingmeter: return String(localized: "Parquímetro")
        case .bench: return String(localized: "Banco")
        case .bird: return String(localized: "Pássaro")
        case .cat: return String(localized: "Gato")
        case .dog: return String(localized: "Cachorro")
        case .horse: return String(localized: "Cavalo")
        case .sheep: return String(localized: "Ovelha")
        case .cow: return String(localized: "Vaca")
        case .elephant: return String(localized: "Elefante")
        case .bear: return String(localized: "Urso")
        case .zebra: return String(localized: "Zebra")
        case .giraffe: return String(localized: "Girafa")
        case .backpack: return String(localized: "Mochila")
        case .umbrella: return String(localized: "Guarda-chuva")
        case .handbag: return String(localized: "Bolsa de mão")
        case .tie: return String(localized: "Gravata")
        case .suitcase: return String(localized: "Mala")
        case .frisbee: return String(localized: "Frisbee")
        case .skis: return String(localized: "Esquis")
        case .snowboard: return String(localized: "Snowboard")
        case .sportsball: return String(localized: "Bola esportiva")
        case .kite: return String(localized: "Pipa")
        case .baseballbat: return String(localized: "Taco de beisebol")
        case .baseballglove: return String(localized: "Luva de beisebol")
        case .skateboard: return String(localized: "Skate")
        case .surfboard: return String(localized: "Prancha de surfe")
        case .tennisracket: return String(localized: "Raquete de tênis")
        case .bottle: return String(localized: "Garrafa")
        case .wineglass: return String(localized: "Taça de vinho")
        case .cup: return String(localized: "Copo")
        case .fork: return String(localized: "Garfo")
        case .knife: return String(localized: "Faca")
        case .spoon: return String(localized: "Colher")
        case .bowl: return String(localized: "Tigela")
        case .banana: return String(localized: "Banana")
        case .apple: return String(localized: "Maçã")
        case .sandwitch: return String(localized: "Sanduíche")
        case .orange: return String(localized: "Laranja")
        case .broccoli: return String(localized: "Brócolis")
        case .carrot: return String(localized: "Cenoura")
        case .hotdog: return String(localized: "Cachorro-quente")
        case .pizza: return String(localized: "Pizza")
        case .donut: return String(localized: "Donut")
        case .cake: return String(localized: "Bolo")
        case .chair: return String(localized: "Cadeira")
        case .sofa: return String(localized: "Sofá")
        case .pottedplant: return String(localized: "Vaso de planta")
        case .bed: return String(localized: "Cama")
        case .diningtable: return String(localized: "Mesa de jantar")
        case .toilet: return String(localized: "Vaso sanitário")
        case .tvmonitor: return String(localized: "Monitor/TV")
        case .laptop: return String(localized: "Laptop")
        case .mouse: return String(localized: "Mouse")
        case .remote: return String(localized: "Controle remoto")
        case .keyboard: return String(localized: "Teclado")
        case .cellphone: return String(localized: "Celular")
        case .microwave: return String(localized: "Micro-ondas")
        case .oven: return String(localized: "Forno")
        case .toaster: return String(localized: "Torradeira")
        case .sink: return String(localized: "Pia")
        case .refrigerator: return String(localized: "Geladeira")
        case .book: return String(localized: "Livro")
        case .vase: return String(localized: "Vaso")
        case .scissors: return String(localized: "Tesoura")
        case .teddybear: return String(localized: "Ursinho de pelúcia")
        case .hairdrier: return String(localized: "Secador de cabelo")
        case .toothbrush: return String(localized: "Escova de dentes")
        }
    }
}
