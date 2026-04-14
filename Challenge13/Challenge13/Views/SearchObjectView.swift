//
//  SearchView.swift
//  Challenge13
//
//  Created by Daniela Valadares on 09/04/26.
//

import SwiftUI
import AVFoundation

struct SearchObjectView: View {
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

#Preview{
    SearchObjectView()
}
