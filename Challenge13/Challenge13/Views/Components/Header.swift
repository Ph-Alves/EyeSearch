//
//  Header.swift
//  EyeSearch
//
//  Created by Raquel Souza on 28/04/26.
//

import SwiftUI

struct Header: View {
    let title: String
    let description: String
    let onAction: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ReturnButton(action: onAction)

            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(description)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    Header(title: "Ajustes", description: "Sua tela de ajustes", onAction: {})
}
