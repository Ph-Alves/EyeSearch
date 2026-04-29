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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    var stickerVM: StickerViewModel
    
    @State var quantity: Int = 1
    
    // MARK: - Body View
    var body: some View {
        ZStack {
            Color.background
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        
                        Header(title: .localized(L10n.Sticker.Screen.title), description: .localized(L10n.Sticker.Screen.description), onAction: { coordinator.pop() })
                        
                        // Imagem com moldura branca
                        ZStack {
                            Image("adesivoPrinter")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 215, height: 215)
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Quantidade + Stepper na mesma linha
                        HStack(alignment: .center) {
                            Text("Quantidade:")
                                .font(.title)
                                .foregroundStyle(.titleText)
                            
                            Spacer()
                            
                            CustomStepperView(quantity: $quantity)
                        }
                        .padding(.horizontal, 4)
                    }
                    .padding(.horizontal, 25)
                    
                    GeneratePDFButton {
                        stickerVM.generatePDF(stickerQuantity: quantity)
                        coordinator.navigate(to: .stickerPreview)
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 32)
                }
            }
        }
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
