//
//  PrintStickerView.swift
//  Challenge13
//
//  Created by Daniela Valadares on 09/04/26.
//

import SwiftUI

struct PrintStickerView: View {
    // MARK: - Variables
    @Environment(Coordinator.self) private var coordinator
    
    var data: Data
    @State private var viewModel = PrintStickerViewModel()
    
    // MARK: - Body View
    var body: some View {
        VStack {
            ReturnButton(action: {
                coordinator.pop()
            })
            viewModel.getView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if let document = viewModel.getDoc() {
                ShareLink(
                    item: document,
                    preview: SharePreview("Adesivos.pdf", image: Image("sticker"))
                ) {
                    Label("Exportar PDF", systemImage: "square.and.arrow.up")
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear() {
            viewModel.setPDFData(data: data)
        }
    }
}

// MARK: - Preview
#Preview {
    CoordinatedNavigationStack {
        PrintStickerView(data: Data())
    }
    .environment(Coordinator())
}
