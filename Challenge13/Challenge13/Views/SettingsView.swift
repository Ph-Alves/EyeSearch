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
    @State var settingsVM: SettingsViewModel
    
    // MARK: - Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 12) {
            
            ReturnButton(action: {
                 coordinator.pop()
            })
            
            Text("Ajustes")
                .font(.largeTitle)
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.top, 12)
        .padding(.bottom, 24)
    }

    
    // MARK: - Body View
    var body: some View {

        ZStack {
            Color(.background)
                .ignoresSafeArea()

            ScrollView{
                VStack(alignment: .leading, spacing: 12) {

                    // MARK: Botão Voltar
                    header

                    VStack(spacing: 40) {
                        // MARK: Vibração
                        SettingsToggleRow(
                            icon: "iphone.radiowaves.left.and.right",
                            titulo: "Vibração",
                            descricao: "Lorem Ipsum Dolor Sit Amet",
                            isOn: Binding(
                                //ele lê o valor atual
                                get: { settingsVM.settings.isHapticsEnabled },
                                //Quando o toggle muda, chama o ViewModel, que persiste e atualiza o valor
                                set: { settingsVM.toggleHaptics($0) }
                            )
                        )

                        // MARK: Som
                        SettingsToggleRow(
                            icon: "speaker.wave.2.fill",
                            titulo: "Som",
                            descricao: "Lorem Ipsum Dolor Sit Amet",
                            isOn: Binding(
                                get: { settingsVM.settings.isSoundEnabled },
                                set: { settingsVM.toggleSound($0) }
                            )
                        )
                        
                        //MARK: - Botão Resetar
                        Button(action: {
                            settingsVM.resetConfiguration()
                            print("Resetar clicado")
                        }) {
                            HStack(spacing: 14) {
                                Image(systemName: "arrow.clockwise")
                                    .font(.title3)
                                    .foregroundStyle(.titleText)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Resetar")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundStyle(.titleText)
                                }

                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 18)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(.settingsPrimary))
                                    .stroke(Color(.settingsPrimaryBorder), lineWidth: 4)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    Text("Descrição")
                        .font(.subheadline)
                        .foregroundStyle(.titleText.opacity(0.75))
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.leading, 4)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    CoordinatedNavigationStack {
        SettingsView(settingsVM: SettingsViewModel(haptics: HapticsManager(), soundManager: SoundManager(), settingsManager: SettingsManager())
        )
    }
    .environment(Coordinator(dependencyContainer: DependencyContainer()))
}
