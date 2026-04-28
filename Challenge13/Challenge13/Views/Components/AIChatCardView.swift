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
            Image(systemName: "message.fill")
                .font(.title)
            
            
            Text("EyeChat")
                .font(.title2)
                .bold()
                .foregroundColor(.titleText)
                .padding(16)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.title)
                .bold()
        }
        .padding()
        .frame(maxWidth: .infinity, minHeight: 80, alignment: .leading)
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

#Preview {
    ZStack {
        Color.background
            .ignoresSafeArea()
        
        AIChatCardView()
            .padding()
    }
    .preferredColorScheme(.dark)
}

