//
//  PDFManaging.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 17/04/26.
//

import Foundation

// MARK: - Protocol
/// # Protocol - PDFManaging
/// Interface para geração de documentos PDF com adesivos para recorte.
/// ## Implementado por:
/// - ``PDFManager``
protocol PDFManaging {
    /// Singleton
    static let shared: PDFManaging { get }
    /// Gera um PDF contendo adesivos distribuídos em folha A4.
    /// - Parameter quantity: Número de adesivos a incluir no PDF.
    /// - Returns: Os dados binários do PDF, ou `nil` se a imagem do adesivo não for encontrada.
    func generatePDF(quantity: Int) -> Data?
}
