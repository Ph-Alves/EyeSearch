//
//  HintsView.swift
//  Challenge13
//
//  Created by Daniela Valadares on 09/04/26.
//

import SwiftUI

struct HintsView: View {
    // MARK: - Variables
    @Environment(Coordinator.self) private var coordinator
    
    // MARK: - Body View
    var body: some View {
        VStack {
            // Volta a view anterior
            ReturnButton(action: {
                coordinator.pop()
            })
            Text("Hints View")
            Button {
                coordinator.navigate(to: HomeDestination.chat)
            } label: {
                Text("CHATBOT")
                    .bold()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview
#Preview {
    CoordinatedNavigationStack {
        HintsView()
    }
    .environment(Coordinator())
    .environment(\.dynamicTypeSize, .large)
}
