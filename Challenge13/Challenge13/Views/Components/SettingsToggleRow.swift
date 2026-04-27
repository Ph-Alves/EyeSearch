//
//  SettingsToggleRow.swift
//  EyeSearch
//
//  Created by Raquel Souza on 24/04/26.
//


import SwiftUI

struct SettingsToggleRow: View {
    let icon: String
    let titulo: String
    let descricao: String
    @Binding var isOn: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundStyle(.titleText)

                Text(titulo)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.titleText)
                    .fixedSize(horizontal: false, vertical: true)

                Spacer()

                Toggle("", isOn: $isOn)
                    .labelsHidden()
                    .tint(.green)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 18)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.settingsPrimary))
                    .stroke(Color(.settingsPrimaryBorder), lineWidth: 4)
            )

            Text(descricao)
                .font(.body)
                .foregroundStyle(.titleText)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.leading, 4)
        }
    }
}

#Preview {
    SettingsToggleRow(
        icon: "speaker.wave.2.fill",
        titulo: "Som",
        descricao: "Emitirá som sempre que identificar adesivos",
        isOn: .constant(true)
    )
    .padding()
    .background(Color.background)
}
