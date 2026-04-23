//
//  StickerOverlay.swift
//  EyeSearch
//
//  Created by Paulo Henrique Costa Alves on 22/04/26.
//

import Foundation

// MARK: - Model
/// # Model - StickerOverlay
/// Modelo de dados para enviar para a view para montar o quadrado em cima do objeto encontrado
/// ## Usado em:
/// - ``SearchObjectViewModel``
struct StickerOverlay: Identifiable {
    let id = UUID()
    let boundingBox: CGRect
    let confidence: Float
}
