//
//  PDFKitView.swift
//  EyeSearch
//
//  Created by Paulo Henrique Costa Alves on 28/04/26.
//

import SwiftUI
import PDFKit

/// Wrapper SwiftUI para exibir um `PDFDocument` usando `PDFView` via `UIViewRepresentable`.
struct PDFKitView: UIViewRepresentable {
    /// Documento PDF a ser exibido.
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
