//
//  CameraManager.swift
//  EyeSearch
//
//  Created by Manoel Pedro Prado Sa Teles on 13/04/26.
//

import AVFoundation
import Foundation

protocol CameraManagerDelegate: AnyObject {
    func cameraManager(_ manager: CameraManager, didCapture sampleBuffer: CMSampleBuffer)
}

@Observable
class CameraManager: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    //MARK: Variables
    var isAuthorized = false
    private(set) var session = AVCaptureSession()
    private let videoOutput = AVCaptureVideoDataOutput()
    
    
    weak var delegate: CameraManagerDelegate?
    
    
    //MARK: Functions
    @MainActor
    func checkAuthorization() async {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .authorized:
            isAuthorized = true
            setupSession()
            
        case .notDetermined:
            isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            if isAuthorized {
                setupSession()
            }
            
        default:
            isAuthorized = false
        }
    }
    
    
    private func setupSession() {
        
        //Uses the main rear lens of the iPhone
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        else { return }
        
        guard let input = try? AVCaptureDeviceInput(device: device)
        else { return }
        
        let processingQueue = DispatchQueue(label: "videoProcessing")
        videoOutput.setSampleBufferDelegate(self, queue: processingQueue)
        
        
        session.beginConfiguration()
        session.sessionPreset = .high
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        if session.canAddOutput(videoOutput) {
            session.addOutput(videoOutput)
        }
        
        session.commitConfiguration()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.startRunning()
        }
    }
    
    func stop() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.stopRunning()
        }
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        delegate?.cameraManager(self, didCapture: sampleBuffer)
    }
    
    deinit {
        session.stopRunning()
    }
}
