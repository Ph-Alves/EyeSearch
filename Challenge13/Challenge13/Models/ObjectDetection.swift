//
//  ObjectDetection.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 20/04/26.
//

import Foundation

// MARK: - Model
/// # Model - ObjectDetection
/// Modelo de dados para definir o objeto que foi identificado, a partir de um label
/// e o valor de confiança do objeto que foi identificado pelo modelo
/// ## Usado em:
/// - ``MLModelManager``
/// - ``SearchObjectViewModel``
struct ObjectDetection {
    /// nome do objeto que foi identificado
    let label: String
    /// valor de confiança
    let confidence: Float
}
