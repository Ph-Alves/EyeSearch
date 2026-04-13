//
//  SearchObjectViewModel.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 13/04/26.
//

import Foundation
import AVFoundation
import SwiftUI

struct Detection: Identifiable {
    let id = UUID()
    let label: String
    let confidence: Float
    let boundingBox: CGRect  // Coordenadas normalizadas (0...1)
}

@Observable
class SearchObjectViewModel {
    
    var camera = CameraManager()
    
    func getPermission() async {
        await camera.checkAuthorization()
    }
    
    func getResponse() -> AdesivoDetectorOutput {
        camera.prediction!
    }
    
    func getCameraPreview() -> some View {
        CameraPreview(session: camera.session)
    }
    
    func getView() -> some View {
        CameraPreview(session: camera.session)
    }
}

class PreviewView: UIView {
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }
    
    var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
}

struct CameraPreview: UIViewRepresentable {
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
