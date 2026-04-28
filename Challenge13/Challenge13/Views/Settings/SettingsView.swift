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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    
    @State var settingsVM: SettingsViewModel
    
    // Flag de primeira execução: enquanto false, exibe o onboarding em vez da Home.
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    // MARK: - Header
    ///Esse header engloba o botão voltar e o título da página.
    private var header: some View {
        VStack {
            //botão de voltar a tela
            ReturnButton(action: {
                coordinator.pop()
            })
            
            VStack(alignment: .leading, spacing: 12){
                //título da tela
                Text(verbatim: .localized(L10n.Settings.Screen.title))
                    .fontWeight(.bold)
                    .font(.largeTitle)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 12)
            .padding(.bottom, 24)
        }
    }
        
        //MARK: - Conteúdo da Settings View
         private var content: some View {
            ZStack {
                Color(.background)
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 12) {
                    
                    // MARK: - Botão Voltar e Título da Página
                    header
                    
                    VStack(spacing: 40) {
                        // MARK: - Toggle Vibração
                        SettingsToggleRow(
                            icon: "iphone.radiowaves.left.and.right",
                            titulo: .localized(L10n.Settings.Haptics.title),
                            descricao: .localized(L10n.Settings.Haptics.description),
                            isOn: Binding(
                                //ele lê o valor atual
                                get: { settingsVM.settings.isHapticsEnabled },
                                //Quando o toggle muda, chama o ViewModel, que persiste e atualiza o valor
                                set: { settingsVM.toggleHaptics($0) }
                            )
                        )
                        
                        // MARK: - Toggle Som
                        SettingsToggleRow(
                            icon: "speaker.wave.2.fill",
                            titulo: .localized(L10n.Settings.Sound.title),
                            descricao: .localized(L10n.Settings.Sound.description),
                            isOn: Binding(
                                get: { settingsVM.settings.isSoundEnabled },
                                set: { settingsVM.toggleSound($0) }
                            )
                        )
                        
                        //MARK: - Botão Refazer Onboarding
                        Button(action: {
                            //                            settingsVM.resetConfiguration()
                            hasCompletedOnboarding = false
                        }) {
                            HStack(spacing: 14) {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .font(.title3)
                                    .foregroundStyle(.titleText)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(verbatim: .localized(L10n.Settings.Onboarding.button))
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
                    Text(verbatim: .localized(L10n.Settings.Onboarding.footer))
                        .font(.body)
                        .foregroundStyle(.titleText)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.leading, 4)
                    
                    Spacer()
                }
                .padding(.horizontal, 24)
            }
        }
        // MARK: - Body View
        var body: some View {
            ZStack {
                Color(.background)
                    .ignoresSafeArea()
                
                //Esse IF verifica se o dynamic type do Iphone da pessoa é maior que AX1
                if dynamicTypeSize >= .accessibility2 {
                    // se for, o conteúdo da tela fica dentro de uma scrollView
                    ScrollView {
                        content
                    }
                } else {
                    // se não for, o conteúdo da tela aparece normal
                    content
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

/*
 

 
 
 */
