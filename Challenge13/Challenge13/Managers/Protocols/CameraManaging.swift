//
//  CameraManaging.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 20/04/26.
//

import Foundation
import AVFoundation

// MARK: - Protocol
/// # Protocol - CameraManaging
/// Interface para gerenciamento da câmera do dispositivo.
/// Responsável por autorização, captura de vídeo e controle da sessão `AVCaptureSession`.
/// ## Implementado por:
/// - ``CameraManager``
protocol CameraManaging: AnyObject {
    /// Singleton
    static let shared: CameraManaging { get }
    /// Indica se o usuário autorizou o uso da câmera.
    var isAuthorized: Bool { get }
    /// Indica se o usuário negou o acesso à câmera (ou está restrito por controle parental).
    var isDenied: Bool { get }
    /// Sessão de captura de vídeo do AVFoundation.
    var session: AVCaptureSession { get }
    /// Delegate que recebe os frames capturados pela câmera.
    var delegate: CameraManagerDelegate? { get set }
    
    /// Verifica e solicita permissão de acesso à câmera.
    func checkAuthorization() async
    /// Para ligar/desligar a lanterna ao utilizar a câmera
    ///  - Parameter on: Parâmetro booleano que define se liga ou desliga a lanterna, usando tochMode
    func setTorch(on: Bool)
    /// Para a captura de vídeo.
    func stop()
}

// MARK: - Delegate Protocol
/// # Protocol - CameraManagerDelegate
/// Delegate que recebe os frames de vídeo capturados pela câmera.
/// ## Implementado por:
/// - ``SearchObjectViewModel``
protocol CameraManagerDelegate: AnyObject {
    /// Chamado quando um novo frame é capturado pela câmera.
    /// - Parameters:
    ///   - manager: O manager de câmera que capturou o frame.
    ///   - sampleBuffer: O buffer contendo o frame de vídeo.
    func cameraManager(_ manager: CameraManaging, didCapture sampleBuffer: CMSampleBuffer)
}
