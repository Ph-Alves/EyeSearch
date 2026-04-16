//
//  StickerView.swift
//  Challenge13
//
//  Created by Daniela Valadares on 09/04/26.
//

import SwiftUI
import PDFKit

struct StickerView: View {
    // MARK: - Variables
    @Environment(Coordinator.self) private var coordinator
    
    @State var quantity: Int = 1
    
    private var viewModel = StickerViewModel()
    
    // MARK: - Body View
    var body: some View {
        ReturnButton(action: {
            coordinator.pop()
        })
        VStack(spacing: 20) {
            Text("Gerador de Adesivos")
                .font(.title)
            
            Stepper(
                "Quantidade: \(quantity)",
                value: $quantity,
                in: 1...20
            )
            .padding()
            
            Button(action: {
                viewModel.generatePDF(stickerQuantity: quantity)
            }) {
                Text("Gerar PDF")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
                            
            
            viewModel.getView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if let document = viewModel.getDoc() {
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
        .padding()
        .navigationTitle("PDF")
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview
#Preview {
    CoordinatedNavigationStack {
        StickerView()
    }
    .environment(Coordinator())
}
