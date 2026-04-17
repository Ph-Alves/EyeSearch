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
    
    @State private var settingsManager = SettingsManager()

    @State private var viewModel: SettingsViewModel

    init() {
        let manager = SettingsManager()
        
        self._viewModel = State(
            initialValue: SettingsViewModel(
                settingsManager: manager,
                haptics: HapticsManager(settingsManager: manager)
            )
        )
    }
    
    // MARK: - Body View
    var body: some View {
        VStack {
            ReturnButton(action: {
                coordinator.pop()
            })
            Text("Settings")
            
            Button {
                viewModel.toggleHaptics()
            } label: {
                Text(viewModel.settings.isHapticsEnabled ? "Haptics ON" : "Haptics OFF")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(viewModel.settings.isHapticsEnabled ? Color.green : Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
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

