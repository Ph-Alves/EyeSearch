//
//  MLModelManaging.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 20/04/26.
//

import Foundation
import CoreML
import AVFoundation

// MARK: - Protocol para MLModelManager
protocol MLModelManaging {
    var isLoaded: Bool { get }
    var error: String? { get }
    
    var stickerModel: MLModel? { get }
    var yoloModel: MLModel? { get }
    
    func detectSticker(in buffer: CMSampleBuffer) throws -> [StickerDetection]
    func detectObject(in buffer: CMSampleBuffer) throws -> ObjectDetection?
    func detect(in buffer: CMSampleBuffer) throws -> [CombinedDetection]
}
