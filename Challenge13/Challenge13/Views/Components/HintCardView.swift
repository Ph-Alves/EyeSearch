//
//  HintCardView.swift
//  Challenge13
//
//  Created by Raquel Souza on 17/04/26.
//

import SwiftUI

struct HintCardView: View {
    
    let hint: Hint
    let isExpanded: Bool
    let action: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            // Título
            HStack {
                Text(hint.title)
                    .font(.headline)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(isExpanded ? 180 : 0))
                    .animation(.easeInOut, value: isExpanded)
            }
            
            // Conteúdo
            if isExpanded {
                Text(hint.description)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
        .onTapGesture {
            withAnimation(.easeInOut) {
                action()
            }
        }
    }
}
