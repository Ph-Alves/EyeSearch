//
//  CameraPreview.swift
//  EyeSearch
//
//  Created by Paulo Henrique Costa Alves on 28/04/26.
//

import SwiftUI
import AVFoundation

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
