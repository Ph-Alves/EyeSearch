//
//  MLModelManager.swift
//  EyeSearch
//
//  Created by Manoel Pedro Prado Sa Teles on 14/04/26.
//

import Foundation
import CoreML
import Vision
import CoreMedia   // Para CMSampleBuffer (frames da câmera)

// MARK: - Manager
/// # Manager - MLModelManager
/// Gerencia os modelos de Machine Learning (StickerDetector + YOLOv3) usando CoreML e Vision.
/// Carrega os modelos em background e processa frames da câmera para detecção.
/// ## Usado em:
/// - ``SearchObjectViewModel``
final class MLModelManager: MLModelManaging {
    // MARK: - Variables
    /// Singleton de instância para os modelos
    static var shared: MLModelManager = MLModelManager()
    /// Indica se os modelos foram carregados com sucesso.
    private(set) var isLoaded: Bool = false
    /// Mensagem de erro caso o carregamento falhe.
    private(set) var error: String?
    /// Modelo CoreML para detecção de adesivos.
    private(set) var stickerModel: MLModel?
    /// Modelo CoreML YOLOv3 para detecção de objetos.
    private(set) var yoloModel: MLModel?
    /// Limiar mínimo de confiança para considerar uma detecção válida.
    private(set) var confidenceThreshold: Float = 0.90
    /// Request do Vision para o modelo de adesivos (cache, reutilizado a cada frame).
    private var stickerRequest: VNCoreMLRequest?
    /// Request do Vision para o modelo YOLO (cache, reutilizado a cada frame).
    private var yoloRequest: VNCoreMLRequest?
    
    // MARK: - Init
    private init() {
        loadModels()
    }
    
    // MARK: - Functions
    
    /// Detecta adesivos no frame da câmera, retornando todas as detecções acima do `confidenceThreshold`.
    /// - Parameter buffer: Frame capturado pela câmera.
    /// - Returns: Lista de `StickerDetection` com bounding box e confiança.
    /// - Throws: `NSError` se o modelo de sticker não estiver carregado.
    func detectSticker(in buffer: CMSampleBuffer) throws -> [StickerDetection] {
        
        guard let request = stickerRequest else {
            throw NSError(domain: "MLModelManager", code: -2,
                          userInfo: [NSLocalizedDescriptionKey: "Modelo de sticker não carregado."])
        }
        
        // VNImageRequestHandler prepara o frame da câmera para o Vision processar
        // .rightMirrored corrige a orientação padrão da câmera frontal, usa .right para traseira
        let handler = VNImageRequestHandler(cmSampleBuffer: buffer, orientation: .right)
        try handler.perform([request])
        
        // Vision retorna VNRecognizedObjectObservation para modelos de object detection
        guard let results = request.results as? [VNRecognizedObjectObservation] else {
            return []
        }
        
        return results
            .filter { $0.confidence >= confidenceThreshold }
        
            .map { observation in
                StickerDetection(
                    // boundingBox do Vision usa coordenadas normalizadas com Y invertido (origem no canto inferior esquerdo)
                    // A conversão para UIKit (origem no canto superior esquerdo) deve ser feita na View
                    
                    //IMPORTANTE TEM QUE INVERTER DEVIDO A VIEW (0,0) SER SUPERIOR ESQUERDO E NO VISION SER INFERIOR ESQUERDO
                    
                    boundingBox: observation.boundingBox,
                    confidence: observation.confidence
                )
            }
    }
    
    /// Classifica o objeto principal na cena usando YOLOv3 e retorna o resultado mais confiante.
    /// - Parameter buffer: Frame capturado pela câmera.
    /// - Returns: O objeto detectado com maior confiança, ou `nil` se nenhum for encontrado.
    /// - Throws: `NSError` se o modelo YOLO não estiver carregado.
    func detectObject(in buffer: CMSampleBuffer) throws -> ObjectDetection? {
        
        guard let request = yoloRequest else {
            throw NSError(domain: "MLModelManager", code: -3,
                          userInfo: [NSLocalizedDescriptionKey: "Modelo YOLO não carregado."])
        }
        
        let handler = VNImageRequestHandler(cmSampleBuffer: buffer, orientation: .right)
        try handler.perform([request])
        
        // YOLO retorna VNRecognizedObjectObservation, label + confidence
        guard let results = request.results as? [VNRecognizedObjectObservation] else {
            return nil
        }
        
        // Pega apenas o resultado com maior confiança
        return results
            .filter { $0.confidence >= confidenceThreshold }
            .sorted { $0.confidence > $1.confidence }
            .first
        
            .map { observation in
                ObjectDetection(
                    label: observation.labels.first?.identifier ?? "desconhecido",
                    confidence: observation.confidence
                )
            }
    }
    
    /// Pipeline completo: detecta adesivos e objetos no mesmo frame e combina os resultados.
    /// Só executa o YOLO se encontrar pelo menos um adesivo no frame.
    /// - Parameter buffer: Frame capturado pela câmera.
    /// - Returns: Lista de `CombinedDetection` associando cada adesivo ao objeto detectado.
    /// - Throws: Erro se algum modelo não estiver carregado.
    func detect(in buffer: CMSampleBuffer) throws -> [CombinedDetection] {
        let stickers = try detectSticker(in: buffer)
        
        // Só roda o YOLO se encontrou pelo menos um sticker — economiza processamento
        guard !stickers.isEmpty else { return [] }
        
        let object = try detectObject(in: buffer)
        
        // Associa o mesmo objeto detectado a cada sticker encontrado no frame
        return stickers.map { CombinedDetection(sticker: $0, object: object) }
    }
    
    // MARK: - Helpers
    
    private func loadModels() {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let sticker = try self.loadModel(named: "StickerDetector1")
                let yolo    = try self.loadModel(named: "YOLOv3")
                
                // Adapta os resultados do modelo para que o framework Vision possa entender
                let stickerVN = try VNCoreMLModel(for: sticker)
                let yoloVN    = try VNCoreMLModel(for: yolo)
                
                DispatchQueue.main.async {
                    
                    self.stickerModel   = sticker
                    self.yoloModel      = yolo
                    
                    self.stickerRequest = VNCoreMLRequest(model: stickerVN)
                    self.yoloRequest    = VNCoreMLRequest(model: yoloVN)
                    
                    self.isLoaded       = true
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                }
            }
        }
    }
    
    private func loadModel(named name: String) throws -> MLModel {
        guard let url = Bundle.main.url(forResource: name, withExtension: "mlmodelc") else {
            throw NSError(
                domain: "MLModelManager",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Modelo '\(name)' não encontrado no bundle."]
            )
        }
        return try MLModel(contentsOf: url)
    }
}
