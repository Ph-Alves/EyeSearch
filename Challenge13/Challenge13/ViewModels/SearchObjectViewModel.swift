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

@Observable
class SearchObjectViewModel: CameraManagerDelegate {


    private(set) var detections: [CombinedDetection] = []

    var isModelLoaded: Bool { mlManager.isLoaded }
    var modelError: String? { mlManager.error }


    private var camera = CameraManager()
    private let mlManager = MLModelManager.manager
    private var isProcessing = false


    init() {
        camera.delegate = self
    }


    func getPermission() async {
        await camera.checkAuthorization()
    }
    
    func getCameraPreview() -> some View {
        CameraPreview(session: camera.session)
    }

    func stop() {
        camera.delegate = nil
        camera.stop()
    }


    deinit {
        stop()
    }
}

// MARK:  CameraManagerDelegate
extension SearchObjectViewModel {
    func cameraManager(_ manager: CameraManager, didCapture sampleBuffer: CMSampleBuffer) {
        guard !isProcessing, mlManager.isLoaded else { return }

        isProcessing = true
        defer { isProcessing = false }

        do {
            let results = try mlManager.detect(in: sampleBuffer)
            DispatchQueue.main.async { [weak self] in
                self?.detections = results
            }
        } catch {
            // Frame perdido — normal em pipeline de camera, nao propagar erro
        }
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
