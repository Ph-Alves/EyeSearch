//
//  SearchView.swift
//  Challenge13
//
//  Created by Daniela Valadares on 09/04/26.
//

import SwiftUI
import AVFoundation

struct SearchObjectView: View {
    // MARK: - Variables
    @Environment(Coordinator.self) private var coordinator
    
    var SearchObjectVM: SearchObjectViewModel
    
    // MARK: - Body View
    var body: some View {
        VStack {
            ReturnButton(action: {
                coordinator.pop()
            })
            SearchObjectVM.getCameraPreview()
                .ignoresSafeArea()
        }
        .padding()
        .task {
            await SearchObjectVM.getPermission()
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview
#Preview{
    CoordinatedNavigationStack {
        SearchObjectView(SearchObjectVM: SearchObjectViewModel())
    }
    .environment(Coordinator(dependencyContainer: DependencyContainer()))
}
