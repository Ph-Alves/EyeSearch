//
//  StickerDetection.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 20/04/26.
//

import Foundation

// MARK: - Model
/// # Model - StickerDetection
/// Modelo de dados para definir a área de que está sendo encontrada no modelo
/// de object classification e seu valor de confiança
/// ## Usado em:
/// - ``MLModelManager``
/// - ``SearchObjectViewModel``
struct StickerDetection {
    /// Area de identificação (um retângulo)
    let boundingBox: CGRect
    /// Confiança do modelo
    let confidence: Float
}
