//
//  SearchView.swift
//  Challenge13
//
//  Created by Daniela Valadares on 09/04/26.
//

import SwiftUI
import AVFoundation

// MARK: - View
/// # View - SearchObjectView
/// Tela de busca de objetos adesivados utilizando a câmera do dispositivo.
/// Exibe o preview da câmera e solicita permissão de acesso ao iniciar.
struct SearchObjectView: View {
    // MARK: - Variables
    @Environment(Coordinator.self) private var coordinator
    
    var SearchObjectVM: SearchObjectViewModel
    
    // MARK: - Body View
    var body: some View {
        VStack {
            ReturnButton(action: {
                coordinator.pop()
            })
            // Preview ao vivo da câmera
            SearchObjectVM.getCameraPreview()
                .ignoresSafeArea()
        }
        .padding()
        .task {
            // Solicita permissão de câmera ao aparecer
            await SearchObjectVM.getPermission()
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview
#Preview{
    CoordinatedNavigationStack {
        SearchObjectView(SearchObjectVM: SearchObjectViewModel())
    }
    .environment(Coordinator(dependencyContainer: DependencyContainer()))
}
