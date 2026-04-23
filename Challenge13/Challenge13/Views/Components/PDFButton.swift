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
    
    let generatorText: String = "Gerar PDF"
    let action: () -> Void
    
    // MARK: - Body
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "printer")
                    .font(.title)
                Text(generatorText)
                    .font(.title)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .semibold))
            }
            .foregroundColor(.white)
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

#Preview {
    GeneratePDFButton(action: {})
}
