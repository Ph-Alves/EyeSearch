//
//  OnboardingContinueButton.swift
//  Challenge13
//
//  Created by Manoel Pedro Prado Sa Teles on 24/04/26.
//

import SwiftUI

struct OnboardingContinueButton: View {

    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color("background"))
                .frame(width: 215, height: 45)
                .background(
                    RoundedRectangle(cornerRadius: 22.5, style: .continuous)
                        .fill(Color("titleText"))
                )
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
    }
}

#Preview {
    VStack(spacing: 16) {
        OnboardingContinueButton(title: "Continuar") {}
        OnboardingContinueButton(title: "Começar") {}
    }
    .padding(32)
    .background(Color("background"))
}
