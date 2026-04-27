//
//  EyeSearchWidgetsControl.swift
//  EyeSearchWidgets
//
//  Created by Paulo Henrique Costa Alves on 23/04/26.
//

import AppIntents
import SwiftUI
import WidgetKit

struct EyeSearchSearchControl: ControlWidget {
    var body: some ControlWidgetConfiguration {
        StaticControlConfiguration(
            kind: "group.eyesearch",
        ) {
            ControlWidgetButton(action: OpenSearchObjectWidgetIntent()) {
                Label("Procurar Objeto", systemImage: "magnifyingglass")
            }
        }
        .displayName("Procurar Objeto")
        .description("Abre o app na tela de busca.")
    }
}
