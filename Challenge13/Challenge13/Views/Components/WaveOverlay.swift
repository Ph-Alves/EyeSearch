//
//  WaveOverlay.swift
//  EyeSearch
//
//  Created by Paulo Henrique Costa Alves on 22/04/26.
//

import Foundation
import SwiftUI

// MARK: View de animação ao encontrar adesivo
/// # Component - WaveOverlay
/// Componente responsável por mostrar um efeito de "onda" em volta da
/// câmera, ao encontrar um adesivo
struct WaveOverlay: View {
    // MARK: - Variables
    /// estado de animação
    @State private var animate = false
    /// Quantidade de "ondas"
    private let waveCount = 3
    /// Radius do retângulo
    private let cornerRadius: CGFloat = 5
    /// opacidade da cor do stroke
    private let opacityTrue: Double = 0
    private let opacityFalse: Double = 0.6
    /// width da linha do stroke
    private let lineWidthTrue: CGFloat = 2
    private let lineWidthFalse: CGFloat = 10
    /// valor do efeito de scale
    private let scaleEffectTrue: CGFloat = 0.85
    private let scaleEffectFalse: CGFloat = 1.0
    /// duração da animação
    private let animationDuration: TimeInterval = 1.5
    
    // MARK: - Body View
    var body: some View {
        ZStack {
            ForEach(0 ..< waveCount, id: \.self) { index in
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(
                        Color.green.opacity(animate ? opacityTrue : opacityFalse),
                        lineWidth: animate ? lineWidthTrue : lineWidthFalse
                    )
                    .scaleEffect(animate ? scaleEffectTrue : scaleEffectFalse)
                    .animation(
                        .easeInOut(duration: animationDuration)
                        .repeatForever(autoreverses: false)
                        .delay(Double(index) * 0.5),
                        value: animate
                    )
            }
        }
        .onAppear() {
            animate = true
        }
    }
}
