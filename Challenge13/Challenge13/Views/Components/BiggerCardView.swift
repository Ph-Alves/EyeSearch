//
//  BiggerCardView.swift
//  Challenge13
//
//  Created by Daniela Valadares on 11/04/26.
//

import SwiftUI

// Card maior usado de xSmall até xxLarge
struct BiggerCardView: View {
    let title: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 75, weight: .regular))
                .foregroundColor(.white)
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 270)
        .padding(.vertical, 34)
        .background(color)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }
}
// medidas ainda a refinar com o protótipo de alta
