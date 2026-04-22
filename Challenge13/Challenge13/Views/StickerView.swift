//
//  StickerView.swift
//  Challenge13
//
//  Created by Daniela Valadares on 09/04/26.
//

import SwiftUI
import PDFKit

// MARK: - View
/// # View - StickerView
/// Tela de configuração para geração de adesivos em PDF.
/// Permite selecionar a quantidade de adesivos e navegar para o preview do PDF.
struct StickerView: View {
    // MARK: - Variables
    @Environment(Coordinator.self) private var coordinator
    
    // Quantidade de adesivos selecionada pelo usuário (1 a 20)
    @State var quantity: Int = 1
    var stickerVM: StickerViewModel
    
    // MARK: - Body View
    var body: some View {
        ReturnButton(action: {
            coordinator.pop()
        })
        VStack(spacing: 20) {
            Text("sticker.screen.title")
                .font(.title)

            Stepper(
                "sticker.quantity.label \(quantity)",
                value: $quantity,
                in: 1...20
            )
            .padding()

            Button(action: {
                // Gera o PDF e navega para a tela de preview
                stickerVM.generatePDF(stickerQuantity: quantity)
                coordinator.navigate(to: .stickerPreview)
            }) {
                Text("sticker.button.generatePDF")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("sticker.preview.navigationTitle")
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview
// Se tentarem visualizar pelo preview, a visualização de pdf não vai funcionar.
#Preview {
    CoordinatedNavigationStack {
        StickerView(stickerVM: StickerViewModel(pdfManager: PDFManager()))
    }
    .environment(Coordinator(dependencyContainer: DependencyContainer()))
}
