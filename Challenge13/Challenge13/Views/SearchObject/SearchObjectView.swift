//
//  SearchView.swift
//  Challenge13
//
//  Created by Daniela Valadares on 09/04/26.
//

import SwiftUI
import UIKit
import AVFoundation

// MARK: - View
/// # View - SearchObjectView
/// Tela de busca de objetos adesivados utilizando a câmera do dispositivo.
/// Exibe o preview da câmera e solicita permissão de acesso ao iniciar.
struct SearchObjectView: View {
    // MARK: - Variables
    /// Coordinator
    @Environment(Coordinator.self) private var coordinator
    /// ViewModel responsável pela câmera, detecção e feedback.
    var SearchObjectVM: SearchObjectViewModel
    /// States
    @State private var flashLight: Bool = true
    @State private var showCameraDeniedAlert = false
    @State private var isRotating = false

    /// init
    init(SearchObjectVM: SearchObjectViewModel) {
        self.SearchObjectVM = SearchObjectVM
    }
    /// Espaçamento padrão das seções superior e inferior.
    private var padding: CGFloat = 20
    /// Z-index da camada de preview da câmera.
    private var cameraZIndex: Double = 2
    /// Z-index da camada de efeito visual (WaveOverlay) sobreposta à câmera.
    private var effectZIndex: Double = 3
    
    // MARK: - Body View
    var body: some View {
        
        // MARK: - Parte Superior
        VStack(spacing: 0) {
            
            HStack(alignment: .center) {
                ReturnButton(action: {
                    coordinator.pop()
                })
                
                Spacer()
                
                Button() {
                    flashLight.toggle()
                    SearchObjectVM.setFlashlight(on: flashLight)
                } label: {
                    Image(systemName: flashLight ? "bolt.fill" : "bolt.slash.fill")
                        .font(.title)
                        .foregroundColor(.primary)
                        
                }
                .accessibilityLabel(flashLight ? "Lanterna ligada" : "Lanterna desligada")
            }
            .padding(padding)
            .background(Color.onboardingProgressInactive)
            
            // MARK: - Meio da camera
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
                .zIndex(cameraZIndex)
                
                if SearchObjectVM.stickerCount > 0 {
                    WaveOverlay()
                        .allowsHitTesting(false)
                        .zIndex(effectZIndex)
                }
            }
            
            // MARK: - Parte Inferior
            HStack {
                Spacer()
                VStack {
                    if SearchObjectVM.stickerCount > 0 {
                        
                        HStack(spacing: 15) {
                            Image(systemName: "checkmark")
                                .font(.title)
                                .foregroundColor(.primary)
                                
                            
                            Text(verbatim: .localized(L10n.SearchObject.Screen.stickerCount, SearchObjectVM.stickerCount))
                                .font(.title)
                                .foregroundColor(.primary)
                        }
                        
                        
                    } else {
                        
                        HStack(spacing: 15) {
                            Image(systemName: "progress.indicator")
                                .font(.title)
                                .foregroundColor(.primary)
                                .symbolEffect(.rotate)
                                .onAppear { isRotating = true }
                            
                            Text(verbatim: .localized(L10n.SearchObject.Screen.searchSticker))
                                .font(.title)
                                .foregroundColor(.primary)
                        }
                    }
                }
                Spacer()
            }
            .padding(padding)
            .background(Color.onboardingProgressInactive)
        }
        .task {
            await SearchObjectVM.getPermission()
            showCameraDeniedAlert = SearchObjectVM.isCameraDenied
        }
        .alert("Câmera bloqueada", isPresented: $showCameraDeniedAlert) {
            Button("Abrir Ajustes") {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            Button("Cancelar", role: .cancel) { }
        } message: {
            Text("Para usar o EyeSearch, permita o acesso à câmera em Ajustes > Privacidade & Segurança > Câmera.")
        }
        .preferredColorScheme(.dark)
        .navigationBarBackButtonHidden(true)
        .background(Color.primary)
        .onDisappear() {
            SearchObjectVM.stop()
        }
    }
}

// MARK: - Preview
#Preview{
    CoordinatedNavigationStack {
        SearchObjectView(SearchObjectVM: SearchObjectViewModel(camera: CameraManager.shared, sound: SoundManager.shared, haptics: HapticsManager.shared, mlManager: MLModelManager.shared, settingsManager: SettingsManager.shared))
    }
    .environment(Coordinator(dependencyContainer: DependencyContainer()))
}
