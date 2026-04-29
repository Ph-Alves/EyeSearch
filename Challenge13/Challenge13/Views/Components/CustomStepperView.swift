//
//  CustomStepperView.swift
//  EyeSearch
//
//  Created by Raquel Souza on 23/04/26.
//

import SwiftUI

struct CustomStepperView: View {

    @Environment(\.dynamicTypeSize) private var typeSize
    @Binding var quantity: Int
    @Environment(\.colorScheme) private var colorScheme

    // MARK: - Dynamic Type Groups
    // Grupo 1: .xSmall ... .medium
    // Grupo 2: .large  ... .xxxLarge
    // Grupo 3: .accessibility1 e acima
    // Grupo 4: .accessibility3 e acima → layout vertical (texto em cima, cards embaixo)

    private var isAccessibilityLarge: Bool {
        typeSize >= .accessibility3
    }

    private var stepperSizing: StepperSizing {
        switch typeSize {
        case .xSmall, .small, .medium:
            return StepperSizing(numberFont: 55, numberCardWidth: 141, numberCardHeight: 124, buttonSize: 35, iconSize: 24, stepperCardWidth: 141, stepperCardHeight: 71)
        case .large, .xLarge, .xxLarge, .xxxLarge:
            return StepperSizing(numberFont: 55, numberCardWidth: 141, numberCardHeight: 124, buttonSize: 35, iconSize: 24, stepperCardWidth: 141, stepperCardHeight: 71)
        default:
            return StepperSizing(numberFont: 82.8, numberCardWidth: 196.65, numberCardHeight: 162.15, buttonSize: 54.05, iconSize: 36.8, stepperCardWidth: 196.65, stepperCardHeight: 113.85)
        }
    }

    var body: some View {
        ZStack {
            VStack(spacing: 0) {

                // Retângulo superior (maior) — exibe o número
                RoundedRectangle(cornerRadius: 22)
                    .fill(colorScheme == .dark ? Color(white: 0.3) : Color(white: 0.7))
                    .frame(width: stepperSizing.numberCardWidth, height: stepperSizing.numberCardHeight)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .strokeBorder(Color(.stickerPrimaryBorder), lineWidth: 4)
                    )
                    .overlay(
                        Text("\(quantity)")
                            .font(.system(size: stepperSizing.numberFont, weight: .bold))
                            .foregroundColor(.titleText)
                    )

                // Retângulo inferior (menor) — botões +/-
                RoundedRectangle(cornerRadius: 22)
                    .fill(colorScheme == .dark ? Color(white: 0.4) : Color(white: 0.6))
                    .frame(width: stepperSizing.stepperCardWidth, height: stepperSizing.stepperCardHeight)
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .strokeBorder(Color(.stickerPrimaryBorder), lineWidth: 4)
                    )
                    .overlay(
                        HStack(spacing: 12) {
                            Button {
                                if quantity > 1 { quantity -= 1 }
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color(.stickerPrimary))
                                        .frame(width: stepperSizing.buttonSize, height: stepperSizing.buttonSize)
                                    Image(systemName: "minus")
                                        .font(.system(size: stepperSizing.iconSize, weight: .bold))
                                        .foregroundColor(.titleText)
                                }
                            }

                            Button {
                                quantity += 1
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color(.stickerPrimary))
                                        .frame(width: stepperSizing.buttonSize, height: stepperSizing.buttonSize)
                                    Image(systemName: "plus")
                                        .font(.system(size: stepperSizing.iconSize, weight: .bold))
                                        .foregroundColor(.titleText)
                                }
                            }
                        }
                    )
                    .offset(y: -22)
            }

        }
        .navigationBarHidden(true)
    }

    // MARK: - Stepper Card
//    @ViewBuilder
//    private var stepperCard: some View {
//        VStack(spacing: 0) {
//
//            // Retângulo superior (maior) — exibe o número
//            RoundedRectangle(cornerRadius: 22)
//                .fill(colorScheme == .dark ? Color(white: 0.3) : Color(white: 0.7))
//                .frame(width: stepperSizing.numberCardWidth, height: stepperSizing.numberCardHeight)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 22)
//                        .strokeBorder(Color(.stickerPrimaryBorder), lineWidth: 4)
//                )
//                .overlay(
//                    Text("\(quantity)")
//                        .font(.system(size: stepperSizing.numberFont, weight: .bold))
//                        .foregroundColor(.titleText)
//                )
//
//            // Retângulo inferior (menor) — botões +/-
//            RoundedRectangle(cornerRadius: 22)
//                .fill(colorScheme == .dark ? Color(white: 0.4) : Color(white: 0.6))
//                .frame(width: stepperSizing.stepperCardWidth, height: stepperSizing.stepperCardHeight)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 22)
//                        .strokeBorder(Color(.stickerPrimaryBorder), lineWidth: 4)
//                )
//                .overlay(
//                    HStack(spacing: 12) {
//                        Button {
//                            if quantity > 1 { quantity -= 1 }
//                        } label: {
//                            ZStack {
//                                Circle()
//                                    .fill(Color(.stickerPrimary))
//                                    .frame(width: stepperSizing.buttonSize, height: stepperSizing.buttonSize)
//                                Image(systemName: "minus")
//                                    .font(.system(size: stepperSizing.iconSize, weight: .bold))
//                                    .foregroundColor(.titleText)
//                            }
//                        }
//
//                        Button {
//                            quantity += 1
//                        } label: {
//                            ZStack {
//                                Circle()
//                                    .fill(Color(.stickerPrimary))
//                                    .frame(width: stepperSizing.buttonSize, height: stepperSizing.buttonSize)
//                                Image(systemName: "plus")
//                                    .font(.system(size: stepperSizing.iconSize, weight: .bold))
//                                    .foregroundColor(.titleText)
//                            }
//                        }
//                    }
//                )
//                .offset(y: -22)
//        }
//    }
}

// MARK: - Stepper Sizing Model
private struct StepperSizing {
    let numberFont: CGFloat
    let numberCardWidth: CGFloat
    let numberCardHeight: CGFloat
    let buttonSize: CGFloat
    let iconSize: CGFloat
    let stepperCardWidth: CGFloat
    let stepperCardHeight: CGFloat
}

#Preview {
    PreviewWrapper()
}

// Wrapper para conseguir usar @Binding no preview
struct PreviewWrapper: View {
    @State private var quantity: Int = 3

    var body: some View {
        CustomStepperView(quantity: $quantity)
            .padding()
    }
}
