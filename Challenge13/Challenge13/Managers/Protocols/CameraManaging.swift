//
//  CameraManaging.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 20/04/26.
//

import Foundation
import AVFoundation

protocol CameraManaging: AnyObject {
    var isAuthorized: Bool { get }
    var session: AVCaptureSession { get }
    var delegate: CameraManagerDelegate? { get set }
    
    func checkAuthorization() async
    func stop()
}

protocol CameraManagerDelegate: AnyObject {
    func cameraManager(_ manager: CameraManager, didCapture sampleBuffer: CMSampleBuffer)
}
