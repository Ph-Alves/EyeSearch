//
//  SettingsView.swift
//  Challenge13
//
//  Created by Daniela Valadares on 09/04/26.
//

import SwiftUI

struct SettingsView: View {
    // MARK: - Variables
    @Environment(Coordinator.self) private var coordinator

    @State private var viewModel = SettingsViewModel(haptics: HapticsManager())
    
    // MARK: - Body View
    var body: some View {
        VStack {
            ReturnButton(action: {
                coordinator.pop()
            })
            Text("Settings")
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview
#Preview {
    CoordinatedNavigationStack {
        SettingsView()
    }
    .environment(Coordinator())
}

