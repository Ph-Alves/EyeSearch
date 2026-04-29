//
//  CameraManager.swift
//  EyeSearch
//
//  Created by Manoel Pedro Prado Sa Teles on 13/04/26.
//

import AVFoundation
import Foundation

// MARK: - Manager
/// # Manager - CameraManager
/// Gerencia a câmera traseira do dispositivo utilizando `AVFoundation`.
/// Configura a sessão de captura, verifica autorização e delega os frames capturados.
/// ## Usado em:
/// - ``SearchObjectViewModel``
final class CameraManager: NSObject, CameraManaging, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    // MARK: - Variables
    /// Singleton
    static let shared: CameraManaging = CameraManager()
    /// Indica se o usuário autorizou o acesso à câmera.
    private(set) var isAuthorized = false
    /// Indica se o usuário negou o acesso (ou está restrito). Nesse caso o app deve orientar ao Ajustes.
    private(set) var isDenied = false
    /// Sessão de captura de vídeo do AVFoundation.
    private(set) var session = AVCaptureSession()
    /// Salva o device para permitir ligar a lanterna em camadas posteriores
    private(set) var device: AVCaptureDevice?
    /// Delegate que recebe os frames capturados.
    weak var delegate: CameraManagerDelegate?
    // Saída de vídeo que processa os frames da câmera.
    private let videoOutput = AVCaptureVideoDataOutput()
    
    // MARK: - Init
    override private init() {
        
    }
    
    // MARK: - Functions
    /// Verifica e solicita permissão de acesso à câmera. Se autorizado, configura a sessão.
    @MainActor
    func checkAuthorization() async {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            isDenied = false
            isAuthorized = true
            setupSession()
        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            if granted {
                isDenied = false
                isAuthorized = true
                setupSession()
            } else {
                isDenied = true
                isAuthorized = false
            }
        case .denied, .restricted:
            isDenied = true
            isAuthorized = false
        @unknown default:
            isAuthorized = false
        }
    }
    
    /// Para ligar/desligar a lanterna ao utilizar a câmera
    ///  - Parameter on: Parâmetro booleano que define se liga ou desliga a lanterna, usando tochMode
    func setTorch(on: Bool) {
        guard let device, device.hasTorch else { return }
        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            device.unlockForConfiguration()
        } catch {
            print("Erro ao tentar ligar lanterna")
        }
    }
    
    /// Para a captura de vídeo em background.
    func stop() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.stopRunning()
        }
    }
    
    /// Callback do AVFoundation chamado a cada frame capturado. Delega o buffer ao ``CameraManagerDelegate``.
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        delegate?.cameraManager(self, didCapture: sampleBuffer)
    }
    
    // MARK: - Helpers
    private func setupSession() {
        // Usa a lente traseira principal do iPhone
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        else { return }
        self.device = device
        
        // Cria o input a partir do dispositivo de câmera
        guard let input = try? AVCaptureDeviceInput(device: device)
        else { return }
        
        // Cria fila dedicada para processar os frames sem bloquear a main thread
        let processingQueue = DispatchQueue(label: "videoProcessing")
        videoOutput.setSampleBufferDelegate(self, queue: processingQueue)
        
        // Configura a sessão: define qualidade e conecta input/output
        session.beginConfiguration()
        session.sessionPreset = .high
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }
        
        session.commitConfiguration()
        
        // Inicia a captura em background para não travar a UI
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.startRunning()
        }
    }
    
    deinit {
        session.stopRunning()
    }
}
