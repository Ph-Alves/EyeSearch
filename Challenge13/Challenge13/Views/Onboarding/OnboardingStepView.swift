//
//  OnboardingStepView.swift
//  Challenge13
//
//  Created by Manoel Pedro Prado Sa Teles on 24/04/26.
//

import SwiftUI

struct OnboardingStepView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 0) {
            Text(page.title)
                .font(.system(size: 32, weight: .bold))
                .foregroundStyle(Color("titleText"))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: 340)

            Spacer(minLength: 24)

            imageContent

            Spacer(minLength: 24)

            Text(page.body)
                .font(.system(size: 20))
                .foregroundStyle(Color("titleText"))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: 306)
        }
        .padding(.horizontal, 24)
        .padding(.top, 32)
        .padding(.bottom, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder
    private var imageContent: some View {
        switch page.image {
        case .mp1Composite:
            OnboardingMP1Image()
        case .bordered(let name):
            Image(name)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 326, height: 326)
                .clipped()
                .overlay(
                    Rectangle()
                        .strokeBorder(Color("titleText"), lineWidth: 6)
                )
        case .plain(let name):
            Image(name)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 326, height: 326)
        case .none:
            Color.clear
                .frame(width: 326, height: 326)
        }
    }
}

/// MP1: hand drawing base + phone screenshot overlay. Offsets measured
/// from the Figma frame (149:318) relative to the 326×326 container.
private struct OnboardingMP1Image: View {
    var body: some View {
        ZStack(alignment: .topLeading) {
            Image("onboarding_mp1_hand")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 326, height: 326)

            Image("onboarding_mp1_phone")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 81, height: 177)
                .clipped()
                .offset(x: 91, y: 124)
        }
        .frame(width: 326, height: 326)
    }
}

#Preview("Step 1") {
    OnboardingStepView(page: OnboardingPage.all[0])
        .background(Color("background"))
}

#Preview("Step 4 (no image)") {
    OnboardingStepView(page: OnboardingPage.all[3])
        .background(Color("background"))
}
