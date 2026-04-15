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

// MARK: Results

struct StickerDetection {
    let boundingBox: CGRect
    let confidence: Float
}

struct ObjectDetection {
    let label: String
    let confidence: Float
}

struct CombinedDetection {
    let sticker: StickerDetection
    let object: ObjectDetection?
}

// MARK: Manager

@Observable
class MLModelManager {
    
    static let manager = MLModelManager()
    
    var isLoaded: Bool = false
    var error: String?
    
    private(set) var stickerModel: MLModel?
    private(set) var yoloModel: MLModel?
    
    var confidenceThreshold: Float = 0.5
    
    // Requests do Vision ficam em cache, criados uma vez, reutilizados a cada frame na funções de detect
    private var stickerRequest: VNCoreMLRequest?
    private var yoloRequest: VNCoreMLRequest?
    
    init() {
        loadModels()
    }
    
    // MARK: Load
    
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
    
    // MARK: Inferência
    
    // Detecta o sticker no frame, retorna todas as detecções acima do confidenceThreshold
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
    
    // Classifica o objeto principal na cena e retorna o label mais confiante do YOLO
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
    
    // Pipeline completo: roda sticker + objeto no mesmo frame e combina os resultados
    func detect(in buffer: CMSampleBuffer) throws -> [CombinedDetection] {
        let stickers = try detectSticker(in: buffer)
        
        // Só roda o YOLO se encontrou pelo menos um sticker — economiza processamento
        guard !stickers.isEmpty else { return [] }
        
        let object = try detectObject(in: buffer)
        
        // Associa o mesmo objeto detectado a cada sticker encontrado no frame
        return stickers.map { CombinedDetection(sticker: $0, object: object) }
    }
}
