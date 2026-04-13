//
//  CameraViewTest.swift
//  Challenge13
//
//  Created by Manoel Pedro Prado Sa Teles on 13/04/26.
//

import SwiftUI
import AVFoundation

struct CameraViewTest: View {
    
    @State private var camera = CameraManager()
    
    var body: some View {
        VStack {
            CameraPreview(session: camera.session)
                .ignoresSafeArea()
        }
        .padding()
        .task {
            await camera.checkAuthorization()
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

#Preview {
    CameraViewTest()
}
