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
    
    @State var quantity: Int = 1
    var stickerVM: StickerViewModel
    
    // Quantos adesivos cabem por folha A4
    private let adesivosPerSheet = 24
    
    /// Computed property — calcula automaticamente o número de folhas A4  necessárias com base na quantidade atual de adesivos.
    /// É recalculada toda vez que `quantity` muda.
    private var sheetsNeeded: Int {
        guard quantity > 0 else { return 0 }
        return Int(ceil(Double(quantity) / Double(adesivosPerSheet)))
    }
    
    // MARK: - Body View
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            
            VStack(spacing: 24) {
                
                ReturnButton(action: {
                    coordinator.pop()
                })
                
                // Título + subtítulo
                VStack(alignment: .leading, spacing: 8) {
                    Text("Dicas")
                        .font(.largeTitle)
                    
                    Text("Lorem Ipsum Dolor Sit Amet Dolor Sit Sit Amet Dolor Sit")
                        .font(.body)
                        .foregroundColor(.primary)
                }
                .padding(.top, 8)
                
                //MARK: - Stepper Customizado
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(white: 0.15))
                    .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(.stickerPrimaryBorder), lineWidth: 4)
                        )
                    .overlay(
                        VStack(spacing: 12) {
                            Text("Quantidade de Adesivos")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)

                            HStack {
                                // Botão –
                                Button {
                                    if quantity > 0 { quantity -= 1 }
                                } label: {
                                    Circle()
                                        .fill(Color(white: 0.25))
                                        .frame(width: 44, height: 44)
                                        .overlay(
                                            Text("−")
                                                .font(.system(size: 22, weight: .medium))
                                                .foregroundColor(.white)
                                        )
                                }

                                Spacer()

                                // Número
                                Text("\(quantity)")
                                    .font(.system(size: 72, weight: .bold, design: .rounded))
                                    .foregroundColor(Color(red: 0.96, green: 0.92, blue: 0.82))
                                    .contentTransition(.numericText())
                                    .animation(.spring(duration: 0.3), value: quantity)

                                Spacer()

                                // Botão +
                                Button {
                                    quantity += 1
                                } label: {
                                    Circle()
                                        .fill(Color(white: 0.25))
                                        .frame(width: 44, height: 44)
                                        .overlay(
                                            Text("+")
                                                .font(.system(size: 22, weight: .medium))
                                                .foregroundColor(.white)
                                        )
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.vertical, 20)
                    )
                    .frame(height: 160)
                
                // MARK: - Retangulo para calcular a quantidade de FOLHAS A4
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(white: 0.15))
                    .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color(.stickerPrimaryBorder), lineWidth: 4)
                    )
                    .frame(height: 60)
                    .overlay(
                        HStack(spacing: 8) {
                            Image(systemName: "doc")
                                .foregroundColor(.gray)
                                .font(.system(size: 32))
                            Text("\(quantity) adesivos * \(sheetsNeeded) Folhas A4")
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                    )
                
                //MARK: - Botão GERAR PDF
                Button(action: {
                    // Gera o PDF e navega para a tela de preview
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
            .navigationBarBackButtonHidden(true)
        }
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
