//
//  PDFButton.swift
//  EyeSearch
//
//  Created by Raquel Souza on 23/04/26.
//

import SwiftUI

/// Botão reutilizável para ações de geração de PDF.
/// Exibe ícone à esquerda, label centralizado e chevron à direita.
struct GeneratePDFButton: View {
    // MARK: - Properties
    
    let generatorText: String = "Imprimir"
    let action: () -> Void
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "printer.fill")
                    .font(.title)
                
                Text(generatorText)
                    .font(.title)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.title2)
            }
            .foregroundColor(.titleText)
            .padding(.vertical, 24)
            .padding(.horizontal, 24)
            .background((Color(.stickerPrimary)))
            .frame(maxWidth: .infinity)
            .cornerRadius(22)
            .contentShape(Rectangle())
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.stickerPrimaryBorder, lineWidth: 4)
            )
        }
    }
}

#Preview {
    GeneratePDFButton(action: {})
}
