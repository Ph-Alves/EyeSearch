//
//  StickerViewModel.swift
//  Challenge13
//
//  Created by Raquel Souza on 13/04/26.
//

import PDFKit
import Combine
import SwiftUI

// Para permitir reatividade
@Observable
class StickerViewModel {
    // MARK: - Variables
    
    // Manager
    private let pdfManager: PDFManaging
    // Data do pdf
    private var pdfData: Data?
    // Documento gerado
    private var pdfDocument: PDFDocument?
    // Preview do doc
    private var pdfView: PDFKitView?
    
    // MARK: - Init
    init (pdfManager: PDFManaging) {
        self.pdfManager = pdfManager
    }
    
    // MARK: - Functions
    
    // Função para gerar o pdf com a quantidade de adesivos
    func generatePDF(stickerQuantity: Int) {
        self.pdfData = pdfManager.generatePDF(quantity: stickerQuantity)
        defineDocument()
    }
    
    // Função para pegar o doc personalizado
    func getDoc() -> CustomPDFDoc? {
        guard let pdfData = self.pdfData else { return nil }
        return CustomPDFDoc(data: pdfData)
    }
    
    func getView() -> PDFKitView? {
        guard let document = self.pdfDocument else { return nil }
        self.pdfView = PDFKitView(pdfDocument: document)
        return pdfView
    }
    
    // Helper para definir o documento da viewModel assim que o pdf for criado.
    private func defineDocument() {
        guard let pdfData = self.pdfData else { return }
        self.pdfDocument = PDFDocument(data: pdfData)
    }
}

// Estrutura de conversão da UIView de
struct PDFKitView: UIViewRepresentable {
    
    let pdfDocument: PDFDocument
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = pdfDocument
    }
}

