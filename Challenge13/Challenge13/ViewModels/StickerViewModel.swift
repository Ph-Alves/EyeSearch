//
//  StickerViewModel.swift
//  Challenge13
//
//  Created by Raquel Souza on 13/04/26.
//

import PDFKit
import SwiftUI

// MARK: - ViewModel
/// # ViewModel - StickerViewModel
/// ViewModel da tela de geração e preview de adesivos em PDF.
/// Coordena o `PDFManager` para gerar, visualizar e exportar documentos PDF.
/// ## Usado em:
/// - ``StickerView``
/// - ``PrintStickerView``
@Observable
@MainActor
class StickerViewModel {
    // MARK: - Variables
    /// Manager responsável pela geração do PDF.
    private let pdfManager: PDFManaging
    /// Dados binários do PDF gerado.
    private var pdfData: Data?
    /// Documento PDF para exibição no preview.
    private var pdfDocument: PDFDocument?
    /// View de preview do PDF.
    private var pdfView: PDFKitView?
    
    // MARK: - Init
    /// Inicializa com o manager de PDF injetado.
    /// - Parameter pdfManager: Manager que conforma com `PDFManaging`.
    init(pdfManager: PDFManaging) {
        self.pdfManager = pdfManager
    }
    
    // MARK: - Functions
    /// Gera o PDF com a quantidade especificada de adesivos.
    /// - Parameter stickerQuantity: Número de adesivos a incluir no PDF.
    func generatePDF(stickerQuantity: Int) {
        self.pdfData = pdfManager.generatePDF(quantity: stickerQuantity)
        defineDocument()
    }
    
    /// Retorna o documento PDF encapsulado para exportação via `ShareLink`.
    /// - Returns: Instância de `CustomPDFDoc`, ou `nil` se o PDF não foi gerado.
    func getDoc() -> CustomPDFDoc? {
        guard let pdfData = self.pdfData else { return nil }
        return CustomPDFDoc(data: pdfData)
    }
    
    /// Retorna a view de preview do PDF gerado.
    /// - Returns: Instância de `PDFKitView`, ou `nil` se o documento não existe.
    func getView() -> PDFKitView? {
        guard let document = self.pdfDocument else { return nil }
        self.pdfView = PDFKitView(pdfDocument: document)
        return pdfView
    }
    
    /// Converte os dados binários do PDF em um `PDFDocument` para exibição.
    private func defineDocument() {
        guard let pdfData = self.pdfData else { return }
        self.pdfDocument = PDFDocument(data: pdfData)
    }
}

