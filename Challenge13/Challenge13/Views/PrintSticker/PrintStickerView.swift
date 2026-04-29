//
//  PrintStickerView.swift
//  Challenge13
//
//  Created by Daniela Valadares on 09/04/26.
//

import SwiftUI

// MARK: - View
/// # View - PrintStickerView
/// Tela de preview e exportação do PDF de adesivos gerado.
/// Exibe o documento e permite compartilhar via `ShareLink`.
struct PrintStickerView: View {
    // MARK: - Variables
    @Environment(Coordinator.self) private var coordinator

    var stickerVM: StickerViewModel

    // MARK: - Body View
    var body: some View {
        ZStack {
            
            Color(.background)
                .ignoresSafeArea()
            

            VStack(spacing: 16) {

                // Botão voltar alinhado à esquerda
                HStack {
                    ReturnButton(action: {
                        coordinator.pop()
                    })
                    Spacer()
                }

//                // Texto centralizado
//                Text("Lorem Ipsum Dolor Sit Amet Lorem Ipsum Dolor Sit Amet Lorem Ipsum Dolor Sit")
//                    .font(.body)
//                    .multilineTextAlignment(.center)
//                    .frame(maxWidth: .infinity)
//                    .foregroundStyle(.white)

                // Preview do PDF gerado
                if let stickerView = stickerVM.getView() {
                    stickerView
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.clear)
                        )
                }

                // Botão salvar via ShareLink
                if let document = stickerVM.getDoc() {
                    ShareLink(
                        item: document,
                        preview: SharePreview("Adesivos.pdf", image: Image("sticker"))
                    ) {
                        Label("Exportar PDF", systemImage: "square.and.arrow.up")
                            .foregroundColor(.titleText)
                            .padding(.vertical, 24)
                            .padding(.horizontal, 24)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(.stickerPrimary))
                            )
                    }
                }
            }
            .padding(.horizontal)
            .navigationBarBackButtonHidden(true)
        }
    }
}

// MARK: - Preview
#Preview {
    CoordinatedNavigationStack {
        PrintStickerView(stickerVM: StickerViewModel(pdfManager: PDFManager.shared))
    }
    .environment(Coordinator(dependencyContainer: DependencyContainer()))
}
