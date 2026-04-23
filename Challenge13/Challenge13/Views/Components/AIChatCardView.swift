//
//  AIChatCardView.swift
//  EyeSearch
//
//  Created by Raquel Souza on 22/04/26.
//

import SwiftUI

struct AIChatCardView: View {
    
    var body: some View {
        
        HStack {
            Image(systemName: "iphone.radiowaves.left.and.right")
                .font(.title)
            
            Text("AIChat")
                .font(.title)
                .foregroundColor(.titleText)
                .padding(16)
            
            
            Image(systemName: "chevron.right")
                .font(.headline)
        }
        .padding()
        .background(Color(.hintsPrimary.opacity(0.4)))
        .cornerRadius(12)
        .contentShape(Rectangle())
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.hintsPrimaryBorder, lineWidth: 4)
        )
    }
}

#Preview {
    ZStack {
        Color.background
            .ignoresSafeArea()
        
        AIChatCardView()
            .padding()
    }
}
