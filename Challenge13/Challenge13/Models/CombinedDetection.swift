//
//  CombinedDetection.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 20/04/26.
//

import Foundation

// MARK: - Model
/// # Model - CombinedDetection
/// Modelo de dados para combinar o que foi identificado de objeto junto a identificação do adesivo
/// Combina `StickerDetection` com `ObjectDetection`
/// ## Usado em:
/// - ``MLModelManager``
/// - ``SearchObjectViewModel``
struct CombinedDetection {
    /// Modelo de Identificação do adesivo
    let sticker: StickerDetection
    /// Modelo de Identificação do objeto
    let object: ObjectDetection?
}
