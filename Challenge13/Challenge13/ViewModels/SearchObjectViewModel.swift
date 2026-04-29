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
    /// Manager da câmera.
    private var camera: CameraManaging
    /// Manager do som
    private var sound: SoundManaging
    /// Manager dos haptics
    private var haptics: HapticsManaging
    /// Manager dos modelos de ML.
    private let mlManager: MLModelManaging
    /// Manager das configs
    private let settingsManager: SettingsManaging
    /// Flag para evitar processamento concorrente de frames.
    private var isProcessing = false
    /// Indica que detectou sticker mas ainda não conseguiu falar o label do YOLO
    private var hasPendingSpeech = false

    // MARK: - Init
    init(camera: CameraManaging, sound: SoundManaging, haptics: HapticsManaging, mlManager: MLModelManaging, settingsManager: SettingsManaging) {
        self.camera = camera
        self.sound = sound
        self.haptics = haptics
        self.mlManager = mlManager
        self.settingsManager = settingsManager
        camera.delegate = self
    }

    /// Indica se o usuário negou o acesso à câmera e precisa ser direcionado para Ajustes.
    private(set) var isCameraDenied = false

    // MARK: - Functions
    /// Solicita permissão de acesso à câmera.
    @MainActor
    func getPermission() async {
        await camera.checkAuthorization()
        isCameraDenied = camera.isDenied
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
    func playSoundIfEnabled(label: String?) {
        let now = Date()
        guard now.timeIntervalSince(lastSoundTime) > 1.5 else { return }
        lastSoundTime = now
        
        let settings = settingsManager.load()
        self.sound.playSound(isEnabled: settings.isSoundEnabled)
        guard let notNilLabel = label else { return }
        self.sound.speakLabel(isEnabled: settings.isSoundEnabled,label: notNilLabel)
    }
    
    /// Ativa os haptics baseando-se nas configurações do usuário
    /// para quando um adesivo for encontrado
    func playHapticsIfEnabled() {
        guard Date().timeIntervalSince(lastHapticsTime) > 3.0 else { return }
        lastHapticsTime = Date()
        let settings = settingsManager.load()
        haptics.setEnabled(settings.isHapticsEnabled)
        haptics.trigger()
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
                    // Sticker novo: toca som e haptics imediatamente
                    playHapticsIfEnabled()
                    
                    if let firstLabel = self.objectsLabels.first {
                        // YOLO já classificou — fala o label
                        playSoundIfEnabled(label: firstLabel)
                        self.hasPendingSpeech = false
                    } else {
                        // YOLO não retornou label — toca som e tenta falar nos próximos frames
                        playSoundIfEnabled(label: nil)
                        self.hasPendingSpeech = true
                    }
                } else if self.hasPendingSpeech, self.stickerCount > 0, let firstLabel = self.objectsLabels.first {
                    // Frames seguintes: sticker ainda visível e YOLO retornou label
                    self.sound.speakLabel(
                        isEnabled: self.settingsManager.load().isSoundEnabled,
                        label: firstLabel
                    )
                    self.hasPendingSpeech = false
                }
                
                if self.stickerCount == 0 {
                    self.hasPendingSpeech = false
                }
                self.previousStickerCount = self.stickerCount
            }
        } catch {
            // Frame perdido — normal em pipeline de câmera, não propagar erro
        }
    }
}




