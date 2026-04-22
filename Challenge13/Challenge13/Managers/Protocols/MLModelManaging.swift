//
//  MLModelManaging.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 20/04/26.
//

import Foundation
import CoreML
import AVFoundation

// MARK: - Protocol
/// # Protocol - MLModelManaging
/// Interface para gerenciamento dos modelos de Machine Learning (CoreML + Vision).
/// Responsável por detectar adesivos e objetos nos frames da câmera.
/// ## Implementado por:
/// - ``MLModelManager``
protocol MLModelManaging {
    /// Indica se os modelos foram carregados com sucesso.
    var isLoaded: Bool { get }
    /// Mensagem de erro caso o carregamento dos modelos falhe.
    var error: String? { get }
    
    /// Modelo CoreML para detecção de adesivos.
    var stickerModel: MLModel? { get }
    /// Modelo CoreML YOLOv3 para detecção de objetos.
    var yoloModel: MLModel? { get }
    
    /// Detecta adesivos no frame da câmera.
    /// - Parameter buffer: Frame capturado pela câmera.
    /// - Returns: Lista de detecções de adesivos encontrados.
    /// - Throws: Erro se o modelo não estiver carregado.
    func detectSticker(in buffer: CMSampleBuffer) throws -> [StickerDetection]
    /// Detecta o objeto principal no frame da câmera usando YOLOv3.
    /// - Parameter buffer: Frame capturado pela câmera.
    /// - Returns: O objeto detectado com maior confiança, ou `nil`.
    /// - Throws: Erro se o modelo não estiver carregado.
    func detectObject(in buffer: CMSampleBuffer) throws -> ObjectDetection?
    /// Pipeline completo: detecta adesivos e objetos, combinando os resultados.
    /// - Parameter buffer: Frame capturado pela câmera.
    /// - Returns: Lista de detecções combinadas (adesivo + objeto).
    /// - Throws: Erro se algum modelo não estiver carregado.
    func detect(in buffer: CMSampleBuffer) throws -> [CombinedDetection]
}
