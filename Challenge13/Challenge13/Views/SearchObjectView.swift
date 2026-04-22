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
    @State var flashLight: Bool = true
    
    // MARK: - Body View
    var body: some View {
        VStack {
            HStack {
                ReturnButton(action: {
                    coordinator.pop()
                })
                Spacer()
                Button() {
                    flashLight.toggle()
                    SearchObjectVM.setFlashlight(on: flashLight)
                } label: {
                    Image(systemName: flashLight ? "flashlight.on.fill" : "flashlight.slash")
                }
            }
            .padding()
            
            ZStack {
                // Preview ao vivo da câmera
                SearchObjectVM.getCameraPreview()
                
                GeometryReader { geo in
                    ForEach(SearchObjectVM.stickerOverlays) { overlay in
                        let rect = SearchObjectVM.convertBoundingBox(overlay.boundingBox, in: geo.size)
                        Rectangle()
                            .stroke(Color.green, lineWidth: 2)
                            .frame(width: rect.width, height: rect.height)
                            .position(x: rect.midX, y: rect.midY)
                    }
                }
                .zIndex(2)
            }
            Text("\(SearchObjectVM.stickerCount) adesivos encontrados")
        }
        .padding()
        .task {
            // Solicita permissão de câmera ao aparecer
            await SearchObjectVM.getPermission()
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.primary)
    }
}

// MARK: - Preview
#Preview{
    CoordinatedNavigationStack {
        SearchObjectView(SearchObjectVM: SearchObjectViewModel())
    }
    .environment(Coordinator(dependencyContainer: DependencyContainer()))
}
