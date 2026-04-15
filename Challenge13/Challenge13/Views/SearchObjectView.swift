//
//  SearchView.swift
//  Challenge13
//
//  Created by Daniela Valadares on 09/04/26.
//

import SwiftUI
import AVFoundation

struct SearchObjectView: View {
    // MARK: - Variables
    @Environment(Coordinator.self) private var coordinator
    
    @State private var objectDetection = SearchObjectViewModel()
    
    // MARK: - Body View
    var body: some View {
        ReturnButton(action: {
            coordinator.pop()
        })
        
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

// MARK: - Preview
#Preview{
    CoordinatedNavigationStack {
        SearchObjectView()
    }
    .environment(Coordinator())
}
