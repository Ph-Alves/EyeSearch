//
//  PDFManagerTests.swift
//  EyeSearchTests
//
//  Created by Manoel Pedro Prado Sa Teles on 22/04/26.
//

import XCTest
import PDFKit
import UIKit
@testable import EyeSearch

// MARK: - Test Suite

final class PDFManagerTests: XCTestCase {

    // MARK: Inviáveis — do documento
    //
    // T05 RN06 — Mostrar prévia do adesivo em tela
    // UI test: renderização de PDFKitView é visual, fora do escopo de unit test.

    // MARK: - Propriedades

    private var sut: PDFManaging!

    // MARK: - Setup / Teardown

    override func setUp() {
        super.setUp()
        sut = PDFManager.shared
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - T06 — Imprimir adesivo do tamanho padrão

    func test_GeneratePDF_WithQuantityOne_ReturnsValidData() throws {
        // Arrange
        try skipIfStickerAssetMissing()

        // Act
        let data = try XCTUnwrap(
            sut.generatePDF(quantity: 1),
            "generatePDF deve retornar Data não-nil com quantity=1."
        )

        // Assert
        let document = try XCTUnwrap(
            PDFDocument(data: data),
            "Data retornada deve ser um PDF válido."
        )
        XCTAssertEqual(document.pageCount, 1, "1 adesivo deve gerar exatamente 1 página.")
    }

    // MARK: - Additional coverage

    func test_GeneratePDF_WithQuantityZero_ReturnsValidData() throws {
        // Arrange
        try skipIfStickerAssetMissing()

        // Act — loop não executa, mas context.beginPage() é chamado → 1 página vazia
        let data = try XCTUnwrap(
            sut.generatePDF(quantity: 0),
            "generatePDF deve retornar Data não-nil mesmo com quantity=0."
        )

        // Assert
        let document = try XCTUnwrap(PDFDocument(data: data))
        XCTAssertEqual(
            document.pageCount, 1,
            "quantity=0 deve gerar 1 página vazia (context.beginPage() é sempre chamado)."
        )
    }

    func test_GeneratePDF_WithLargeQuantity_GeneratesMultiplePages() throws {
        // Arrange
        // Layout: sticker 110×110 + spacing 20 + margin 20 em página A4 (595.2×841.8).
        // Stickers/linha = floor((595.2 - 20) / (110 + 20)) = 4.
        // Linhas/página  = floor((841.8 - 20) / (110 + 20)) = 6.
        // Stickers/página = 4 × 6 = 24. quantity=25 → página 2 iniciada → pageCount > 1.
        try skipIfStickerAssetMissing()

        // Act
        let data = try XCTUnwrap(
            sut.generatePDF(quantity: 25),
            "generatePDF deve retornar Data não-nil com quantity=25."
        )

        // Assert
        let document = try XCTUnwrap(PDFDocument(data: data))
        XCTAssertGreaterThan(
            document.pageCount, 1,
            "25 adesivos devem ocupar mais de 1 página A4."
        )
    }
}

// MARK: - Helpers

private extension PDFManagerTests {

    /// Pula os testes se o asset "sticker" não estiver acessível no bundle do host de testes.
    /// Em ambiente normal (test host = EyeSearch.app) o asset é encontrado via Bundle.main.
    func skipIfStickerAssetMissing() throws {
        guard UIImage(named: "sticker") != nil else {
            throw XCTSkip("Asset 'sticker' não encontrado no bundle de testes — PDFManagerTests pulados.")
        }
    }
}
