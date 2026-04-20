//
//  PDFManaging.swift
//  Challenge13
//
//  Created by Paulo Henrique Costa Alves on 17/04/26.
//

import Foundation

// MARK: - Protocol para PDFManager
protocol PDFManaging {
    func generatePDF(quantity: Int) -> Data?
}
