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
        ReturnButton(action: {
            coordinator.pop()
        })
        Text("Hints View")
    }
}

// MARK: - Preview
#Preview {
    CoordinatedNavigationStack {
        HintsView()
    }
    .environment(Coordinator())
}
