//
//  OnboardingProgressBar.swift
//  Challenge13
//

import SwiftUI

struct OnboardingProgressBar: View {
    let currentIndex: Int
    let totalSteps: Int

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<totalSteps, id: \.self) { index in
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(index <= currentIndex ? Color.white : Color("onboardingProgressInactive"))
                    .frame(maxWidth: .infinity)
                    .frame(height: 8)
            }
        }
        .animation(.easeInOut(duration: 0.25), value: currentIndex)
    }
}

#Preview {
    VStack(spacing: 16) {
        OnboardingProgressBar(currentIndex: 0, totalSteps: 5)
        OnboardingProgressBar(currentIndex: 2, totalSteps: 5)
        OnboardingProgressBar(currentIndex: 4, totalSteps: 5)
    }
    .padding(.horizontal, 22)
    .padding(.vertical, 32)
    .background(Color.black)
    .preferredColorScheme(.dark)
}
