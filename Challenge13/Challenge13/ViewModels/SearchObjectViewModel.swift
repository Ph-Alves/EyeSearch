//
//  SearchObjectViewModel.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 13/04/26.
//

import Foundation
import AVFoundation
import SwiftUI
import CoreMedia

// MARK: - ViewModel
/// # ViewModel - SearchObjectViewModel
/// ViewModel da tela de busca de objetos adesivados.
/// Coordena a câmera, o processamento de ML e expõe os resultados de detecção para a view.
/// ## Usado em:
/// - ``SearchObjectView``
@Observable
class SearchObjectViewModel: CameraManagerDelegate {

    // MARK: - Variables
    /// Lista de detecções combinadas (adesivo + objeto) do frame atual.
    private(set) var detections: [CombinedDetection] = []
    /// Indica se os modelos de ML foram carregados com sucesso.
    var isModelLoaded: Bool { mlManager.isLoaded }
    /// Mensagem de erro do carregamento dos modelos, se houver.
    var modelError: String? { mlManager.error }
    var objectsLabels: [String] {
        detections
            .compactMap { detection -> String? in
                guard let object = detection.object else { return nil }
                return object.label
            }
    }
    /// Lista de retângulos de adesivos encontrados, filtrados somente em confiança a 50%
    var stickerOverlays: [StickerOverlay] {
        detections
            .map { StickerOverlay(boundingBox: $0.sticker.boundingBox, confidence: $0.sticker.confidence) }
    }
    /// Quantidade de adesivos encontrados
    var stickerCount: Int {
        stickerOverlays.count
    }
    /// Quantidade antiga de adesivos encontrados
    private var previousStickerCount = 0
    /// Data antiga de quando o som foi tocado
    private var lastSoundTime: Date = .distantPast
    /// Data antiga de quando o haptics foi ativado
    private var lastHapticsTime: Date = .distantPast
    /// Data do que foi falado anteriormente (Yolo)
    private var lastSpeechTime: Date = .distantPast
    /// Manager da câmera.
    private var camera: CameraManaging
    /// Manager do som
    private var sound: SoundManaging
    /// Manager dos haptics
    private var haptics: HapticsManaging
    /// Manager dos modelos de ML.
    private let mlManager: MLModelManaging
    /// Manager das configs
    private let settingsManager: SettingsManager
    /// Flag para evitar processamento concorrente de frames.
    private var isProcessing = false

    // MARK: - Init
    init(camera: CameraManager, sound: SoundManager, haptics: HapticsManager, mlManager: MLModelManager, settingsManager: SettingsManager) {
        self.camera = camera
        self.sound = sound
        self.haptics = haptics
        self.mlManager = mlManager
        self.settingsManager = settingsManager
        camera.delegate = self
    }

    // MARK: - Functions
    /// Solicita permissão de acesso à câmera.
    func getPermission() async {
        await camera.checkAuthorization()
    }
    
    /// Retorna a view de preview da câmera.
    /// - Returns: Uma `CameraPreview` conectada à sessão de captura.
    func getCameraPreview() -> some View {
        CameraPreview(session: camera.session)
    }
        
    /// Altera a lanterna conforme o recebido pela view
    /// - Parameter on: Valor booleano para definir se a lanterna deve desligar ou ligar
    func setFlashlight(on: Bool) {
        camera.setTorch(on: on)
    }
    
    /// Toca o som baseando-se nas configurações do usuário
    /// para quando um adesivo for encontrado e executa uma fala a partir do label recebido pelo Yolo
    /// - Parameter label: Um valor de string recebido do Yolo para ser falado
    func playSoundIfEnabled(label: String) {
        let now = Date()
        guard now.timeIntervalSince(lastSoundTime) > 1.0 else { return }
        guard now.timeIntervalSince(lastSoundTime) > 1.0 else { return }
        lastSpeechTime = now
        lastSoundTime = now
        
        let settings = settingsManager.load()
        self.sound.speakLabel(isEnabled: settings.isSoundEnabled,label: label)
        self.sound.playSound(isEnabled: settings.isSoundEnabled)
    }
    
    /// Ativa os haptics baseando-se nas configurações do usuário
    /// para quando um adesivo for encontrado
    func activeHapticsIfEnabled() {
        guard Date().timeIntervalSince(lastHapticsTime) > 3.0 else { return }
        lastHapticsTime = Date()
        let settings = settingsManager.load()
        haptics.trigger(isEnabled: settings.isHapticsEnabled)
    }
    
    /// Converte boundingBox para coordenadas swiftUI
    /// - Returns: Um CGRect normalizado para uma view SwiftUI
    func convertBoundingBox(_ box: CGRect, in viewSize: CGSize) -> CGRect {
        return CGRect (
            x: box.origin.x * viewSize.width,
            y: (1 - box.origin.y - box.height) * viewSize.height,
            width: box.width * viewSize.width,
            height: box.height * viewSize.height
        )
    }

    /// Para a captura de vídeo e desconecta o delegate.
    func stop() {
        camera.delegate = nil
        camera.stop()
    }

    deinit {
        stop()
    }
}

// MARK: - CameraManagerDelegate
extension SearchObjectViewModel {
    /// Recebe cada frame capturado pela câmera e executa a detecção de adesivos e objetos.
    func cameraManager(_ manager: CameraManaging, didCapture sampleBuffer: CMSampleBuffer) {
        // Ignora se já está processando um frame ou se os modelos não carregaram
        guard !isProcessing, mlManager.isLoaded else { return }

        isProcessing = true
        defer { isProcessing = false }

        do {
            // Executa o pipeline de detecção (sticker + YOLO)
            let results = try mlManager.detect(in: sampleBuffer)
            // Atualiza os resultados na main thread para a view reagir
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.detections = results
                
                if self.stickerCount > self.previousStickerCount {
                    if let firstLabel = self.objectsLabels.first {
                        playSoundIfEnabled(label: firstLabel)
                    }
                    activeHapticsIfEnabled()
                }
                self.previousStickerCount = self.stickerCount
            }
        } catch {
            // Frame perdido — normal em pipeline de câmera, não propagar erro
        }
    }
}

/// UIView customizada que utiliza `AVCaptureVideoPreviewLayer` como layer principal.
/// Necessária porque `AVCaptureVideoPreviewLayer` precisa ser o layer root da view.
class PreviewView: UIView {
    // Substitui o layer padrão (CALayer) pelo layer de preview da câmera
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    // Atalho para acessar o layer já tipado
    var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
}

/// Wrapper SwiftUI para exibir o preview da câmera usando `UIViewRepresentable`.
struct CameraPreview: UIViewRepresentable {
    /// Sessão de captura de vídeo a ser exibida.
    let session: AVCaptureSession
    
    init(session: AVCaptureSession) {
        self.session = session
    }
    
    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }
    
    func updateUIView(_ uiView: PreviewView, context: Context) {}
}
