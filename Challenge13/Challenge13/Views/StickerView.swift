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

    var stickerVM: StickerViewModel
    
    @State var quantity: Int = 1
    
    // Quantos adesivos cabem por folha A4
    private let adesivosPerSheet = 24
    
    /// Computed property — calcula automaticamente o número de folhas A4  necessárias com base na quantidade atual de adesivos.
    /// É recalculada toda vez que `quantity` muda.
    private var sheetsNeeded: Int {
        guard quantity > 0 else { return 0 }
        return Int(ceil(Double(quantity) / Double(adesivosPerSheet)))
    }
    
    
    // MARK: - Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            ReturnButton(action: {
                 coordinator.pop()
            })
            
            Text("Imprimir Adesivo")
                .font(.largeTitle)
            
            Text("Lorem Ipsum Dolor Sit Amet Lorem Ipsum Dolor Sit Amet Lorem Ipsum Dolor Sit")
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.top, 12)
    }
    
    // MARK: - Body View
    var body: some View {

        ZStack {
            Color(.background)
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        header
                        
                        CustomStepperView(quantity: $quantity)
                        A4InfoCardView(quantity: quantity, sheetsNeeded: sheetsNeeded)
                        
                        Spacer()
                        
                        GeneratePDFButton {
                            stickerVM.generatePDF(stickerQuantity: quantity)
                            coordinator.navigate(to: .stickerPreview)
                        }

                    }
                    .padding()
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
