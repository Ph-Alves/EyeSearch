//
//  CameraViewTest.swift
//  Challenge13
//
//  Created by Manoel Pedro Prado Sa Teles on 13/04/26.
//

import SwiftUI
import AVFoundation

struct CameraViewTest: View {
    
    @State private var objectDetection = SearchObjectViewModel()
    
    var body: some View {
        VStack {
            objectDetection.getCameraPreview()
                .ignoresSafeArea()
        }
        .padding()
        .task {
            await objectDetection.getPermission()
        }
    }
}

#Preview {
    CameraViewTest()
}
