//
//  CompactCardView.swift
//  Challenge13
//
//  Created by Daniela Valadares on 11/04/26.
//

import SwiftUI

// Card compacto usado com o dinamic type do xSmall ao xxLarge
struct CompactCardView: View {
    let title: String
    let icon: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 25, weight: .regular))
                .foregroundColor(.white)
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 64)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}
// medidas ainda a refinar com o protótipo de alta
