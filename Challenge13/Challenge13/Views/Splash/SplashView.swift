//
//  SplashView.swift
//  EyeSearch
//

import SwiftUI
import UIKit

// MARK: - FrameAnimationView
/// Reproduz os frames uma vez terminando no primeiro frame.
private struct FrameAnimationView: UIViewRepresentable {
    let frames: [UIImage]
    let fps: Double

    func makeUIView(context: Context) -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.animationImages = frames
        imageView.animationDuration = Double(frames.count) / fps
        imageView.animationRepeatCount = 1
        imageView.image = frames.first          // segura o frame 1 ao terminar
        imageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.startAnimating()
        return imageView
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIImageView, context: Context) -> CGSize? {
        CGSize(width: proposal.width ?? 200, height: proposal.height ?? 200)
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {}
}

// MARK: - SplashView
/// # View - SplashView
/// Animação toca uma vez (volta ao primeiro frame) → fade out.
/// Duração total: 0.5s (0.3s animação + 0.2s fade out).
/// ## Usado em:
/// - ``Challenge13App``
struct SplashView: View {
    // MARK: - Variables
    let onFinished: () -> Void

    // 15 frames em 0.3s = 50fps | fade out = 0.2s | total = 0.5s
    private let fps: Double = 30
    private let fadeDuration: Double = 0.6

    @State private var opacity: Double = 1

    private var frames: [UIImage] {
        var forward: [UIImage] = []
        var index = 1
        while let frame = UIImage(named: "ICONE_APP_ANIMAÇÃO-\(index)") {
            forward.append(frame)
            index += 1
        }
        // 1→N depois N-1→1, terminando no frame 1
        let reverse = Array(forward.dropLast().reversed())
        return forward + reverse
    }

    private var animationDuration: Double {
        frames.isEmpty ? 0.3 : Double(frames.count) / fps
    }

    // MARK: - Body View
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()

            VStack(spacing: 24) {
               
                FrameAnimationView(frames: frames, fps: fps)
                    .frame(width: 200, height: 200)
                

                Text("EyeSearch")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(Color(.titleText))
            }
            .opacity(opacity)
        }
        .preferredColorScheme(.dark)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration) {
                withAnimation(.easeIn(duration: fadeDuration)) {
                    opacity = 0
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + fadeDuration) {
                    onFinished()
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SplashView(onFinished: {})
}
