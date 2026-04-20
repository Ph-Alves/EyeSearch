//
//  SettingsView.swift
//  Challenge13
//
//  Created by Daniela Valadares on 09/04/26.
//

import SwiftUI

// MARK: - View
/// # View - SettingsView
/// Tela de configurações do app.
/// Permite ao usuário ajustar preferências de haptics e som.
struct SettingsView: View {
    // MARK: - Variables
    @Environment(Coordinator.self) private var coordinator

    var settingsVM: SettingsViewModel
    
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
        SettingsView(settingsVM: SettingsViewModel(haptics: HapticsManager(), soundManager: SoundManager(), settingsManager: SettingsManager()))
    }
    .environment(Coordinator(dependencyContainer: DependencyContainer()))
}

