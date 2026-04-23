//
//  A4InfoCardView.swift
//  EyeSearch
//
//  Created by Raquel Souza on 23/04/26.
//

import SwiftUI

struct A4InfoCardView: View {
    let quantity: Int
    let sheetsNeeded: Int
    
    var body: some View {
        // MARK: - Retangulo para calcular a quantidade de FOLHAS A4
        HStack(spacing: 8) {
            Image(systemName: "doc")
                .foregroundColor(.gray)
            Text("\(quantity) adesivos - \(sheetsNeeded) Folhas A4")
                .foregroundColor(.white)
        }
        .font(.body)
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(white: 0.15))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(.stickerPrimaryBorder), lineWidth: 4)
            )
        )
    }
}

