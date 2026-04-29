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

            VStack(spacing: 0) {

                // Botão voltar
                HStack {
                    ReturnButton(action: { coordinator.pop() })
                }

                // Preview do PDF gerado
                if let stickerView = stickerVM.getView() {
                    stickerView
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }

                // Botão salvar via ShareLink
                if let document = stickerVM.getDoc() {
                    ShareLink(
                        item: document,
                        preview: SharePreview("Adesivos.pdf", image: Image("sticker"))
                    ) {
                        ExportButton()
                    }
                }
            }
            .padding(.horizontal, 25)
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
