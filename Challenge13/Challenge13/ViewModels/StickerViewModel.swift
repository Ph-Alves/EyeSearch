//
//  StickerViewModel.swift
//  Challenge13
//
//  Created by Raquel Souza on 13/04/26.
//

import PDFKit
import Combine

class StickerViewModel: ObservableObject {
    
    @Published var quantity: Int = 1
    @Published var pdfDocument: PDFDocument?
    @Published var pdfData: Data = Data()
    
    func generatePDF() {
        let data = PDFManager.generatePDF(quantity: quantity)
        pdfData = data 
        pdfDocument = PDFDocument(data: data)
    }
}
