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
    /// Lista de retângulos de adesivos encontrados, filtrados somente em confiança a 50%
    var stickerOverlays: [StickerOverlay] {
        detections
            .filter({ $0.sticker.confidence > 0.6 })
            .map { StickerOverlay(boundingBox: $0.sticker.boundingBox, confidence: $0.sticker.confidence) }
    }
    /// Quantidade de adesivos encontrados
    var stickerCount: Int {
        stickerOverlays.count
    }
    /// Indica se os modelos de ML foram carregados com sucesso.
    var isModelLoaded: Bool { mlManager.isLoaded }
    /// Mensagem de erro do carregamento dos modelos, se houver.
    var modelError: String? { mlManager.error }
    /// Referência ao preview layer para conversão de coordenadas
    private var previewLayer: AVCaptureVideoPreviewLayer?
    /// Manager da câmera.
    private var camera = CameraManager()
    /// Manager dos modelos de ML.
    private let mlManager = MLModelManager.shared
    /// Flag para evitar processamento concorrente de frames.
    private var isProcessing = false

    // MARK: - Init
    init() {
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
    
    /// Função para definir o previewLayer da viewModel
    /// - Parameter layer: Recebe um AVCaptureViewPreviewLayer para permitir a conversão de coordenadas corretas
    func setPreviewLayer(_ layer: AVCaptureVideoPreviewLayer) {
        self.previewLayer = layer
    }
    
    /// Converte boundingBox para coordenadas swiftUI
    /// - Returns: Um CGRect normalizado para uma view SwiftUI
    func convertBoundingBox(_ box: CGRect, in viewSize: CGSize) -> CGRect {
        CGRect (
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
                self?.detections = results
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
    /// Referência ao preview layer para conversão de coordenadas corretas
    var onLayerReady: ((AVCaptureVideoPreviewLayer) -> Void)?
    
    init(session: AVCaptureSession) {
        self.session = session
    }
    
    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }
    
    func updateUIView(_ uiView: PreviewView, context: Context) {
        DispatchQueue.main.async {
            onLayerReady?(uiView.previewLayer)
        }
    }
}
