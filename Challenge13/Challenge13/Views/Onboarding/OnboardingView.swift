//
//  OnboardingView.swift
//  Challenge13
//
//  Created by Manoel Pedro Prado Sa Teles on 24/04/26.
//

import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    @State private var currentPage: Int = 0
    private let pages = OnboardingPage.all

    var body: some View {
        ZStack {
            Color("background")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                OnboardingProgressBar(currentIndex: currentPage, totalSteps: pages.count)
                    .padding(.horizontal, 22)
                    .padding(.top, 16)

                TabView(selection: $currentPage) {
                    ForEach(pages) { page in
                        OnboardingStepView(page: page)
                            .tag(page.id)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                OnboardingContinueButton(title: pages[currentPage].buttonTitle) {
                    advance()
                }
                .padding(.bottom, 32)
            }
        }
    }

    private func advance() {
        if currentPage < pages.count - 1 {
            withAnimation(.easeInOut(duration: 0.25)) {
                currentPage += 1
            }
        } else {
            hasCompletedOnboarding = true
        }
    }
}

#Preview {
    OnboardingView()
}
