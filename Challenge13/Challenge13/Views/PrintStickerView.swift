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
        VStack {
            ReturnButton(action: {
                coordinator.pop()
            })
            
            // Exibe o preview do PDF gerado
            if let stickerView = stickerVM.getView() {
                stickerView
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // Botão de exportação via ShareLink (só aparece se o PDF foi gerado)
            if let document = stickerVM.getDoc() {
                ShareLink(
                    item: document,
                    preview: SharePreview("Adesivos.pdf", image: Image("sticker"))
                ) {
                    Label("Exportar PDF", systemImage: "square.and.arrow.up")
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview
#Preview {
    CoordinatedNavigationStack {
        PrintStickerView(stickerVM: StickerViewModel(pdfManager: PDFManager()))
    }
    .environment(Coordinator(dependencyContainer: DependencyContainer()))
}
