//
//  ExportButton.swift
//  EyeSearch
//
//  Created by Raquel Souza on 29/04/26.
//
import SwiftUI

struct ExportButton: View {
    let title: String = "Exportar PDF"
    let icon: String = "square.and.arrow.down"
    
    var body: some View {
        HStack {
            Text(title)
                .font(.title)
                .foregroundColor(.titleText)
            
            Spacer()
            
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(.titleText)
                .padding(10)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.stickerPrimary))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.stickerPrimaryBorder, lineWidth: 4)
                )
        )
    }
}

#Preview {
    ExportButton()
}
