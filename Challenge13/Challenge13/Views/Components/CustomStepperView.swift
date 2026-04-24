//
//  CustomStepperView.swift
//  EyeSearch
//
//  Created by Raquel Souza on 23/04/26.
//

import SwiftUI

struct CustomStepperView: View {
    
    @Binding var quantity: Int
    
    var body: some View {
        
        //MARK: - Stepper Customizado
        RoundedRectangle(cornerRadius: 20)
            .fill(Color(white: 0.15))
            .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(.stickerPrimaryBorder), lineWidth: 4)
                )
            .overlay(
                VStack(spacing: 12) {
                    Text("Quantidade de Adesivos")
                        .font(.system(size: 28))
                        .foregroundColor(.gray)

                    HStack {
                        // Botão –
                        Button {
                            if quantity > 1 { quantity -= 1 }
                        } label: {
                            Circle()
                                .fill(Color(white: 0.25))
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Text("−")
                                        .font(.system(size: 24, weight: .medium))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                )
                        }

                        Spacer()

                        // Número
                        Text("\(quantity)")
                            .font(.system(size: 72, weight: .bold, design: .rounded))
                            .foregroundColor(Color(red: 0.96, green: 0.92, blue: 0.82))
                            .contentTransition(.numericText())
                            .animation(.spring(duration: 0.3), value: quantity)

                        Spacer()

                        // Botão +
                        Button {
                            quantity += 1
                        } label: {
                            Circle()
                                .fill(Color(white: 0.25))
                                .frame(width: 48, height: 48)
                                .overlay(
                                    Text("+")
                                        .font(.system(size: 24, weight: .medium))
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 20)
            )
            .frame(height: 200)
        
    }
}

