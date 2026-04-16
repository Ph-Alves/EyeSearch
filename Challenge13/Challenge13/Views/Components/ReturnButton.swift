//
//  ReturnButton.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 15/04/26.
//

import SwiftUI

struct ReturnButton: View {
    // MARK: - Variables
    var action: () -> Void
    
    let returnText: String = "Voltar"
    
    // MARK: - Body view
    var body: some View {
        Button(action: action, label: {
            HStack {
                Image(systemName: "chevron.left")
                    .fontWeight(.bold)
                Text(returnText)
                    .fontWeight(.bold)
            }
        })
    }
}

// MARK: - Preview
#Preview {
    ReturnButton(action: {})
}
