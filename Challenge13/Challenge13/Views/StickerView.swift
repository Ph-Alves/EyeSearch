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
    
    // States
    @State var quantity: Int = 1
    var stickerVM: StickerViewModel
    
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
                stickerVM.generatePDF(stickerQuantity: quantity)
                coordinator.navigate(to: .stickerPreview)
            }) {
                Text("Gerar PDF")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .navigationTitle("PDF")
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview
// Se tentarem visualizar pelo preview, a visualização de pdf não vai funcionar.
#Preview {
    CoordinatedNavigationStack {
        StickerView(stickerVM: StickerViewModel())
    }
    .environment(Coordinator(dependencyContainer: DependencyContainer()))
}
