//
//  CameraManaging.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 20/04/26.
//

import Foundation
import AVFoundation

// MARK: - Protocol para CameraManager
protocol CameraManaging: AnyObject {
    var isAuthorized: Bool { get }
    var session: AVCaptureSession { get }
    var delegate: CameraManagerDelegate? { get set }
    
    func checkAuthorization() async -> Void
    func stop() -> Void
}

// MARK: - Protocolo do delegate da câmera
protocol CameraManagerDelegate: AnyObject {
    func cameraManager(_ manager: CameraManager, didCapture sampleBuffer: CMSampleBuffer)
}
