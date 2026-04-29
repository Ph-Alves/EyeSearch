//
//  StickerViewModelTests.swift
//  EyeSearchTests
//
//  Created by Manoel Pedro Prado Sa Teles on 24/04/26.
//

import XCTest
import UIKit
import PDFKit
@testable import EyeSearch

// MARK: - Spy

private final class PDFManagerSpy: PDFManaging {
    static let shared: PDFManaging = PDFManagerSpy()
    
    private init() {}
    
    private(set) var generatePDFCallCount = 0
    private(set) var lastQuantity: Int?
    var stubbedData: Data? = Data()

    func generatePDF(quantity: Int) -> Data? {
        generatePDFCallCount += 1
        lastQuantity = quantity
        return stubbedData
    }
    
    func reset() {
        self.generatePDFCallCount = 0
        self.lastQuantity = nil
        self.stubbedData = nil
    }
}

// MARK: - Test Suite

final class StickerViewModelTests: XCTestCase {

    // MARK: Inviáveis — do documento
    //
    // T05 RN06 — Mostrar prévia do adesivo em tela
    //   UI test: renderização de PDFKitView é visual, fora do escopo de unit test.

    // MARK: - Propriedades

    private var spy: PDFManagerSpy!
    private var sut: StickerViewModel!

    // MARK: - Setup / Teardown

    override func setUp() async throws {
        try await super.setUp()
        spy = await PDFManagerSpy.shared as? PDFManagerSpy
        sut = await StickerViewModel(pdfManager: spy)
        spy.reset()
    }
    
    override func tearDown() {
        sut = nil
        spy = nil
        super.tearDown()
    }

    // MARK: - Additional coverage

    @MainActor
    func test_Init_DoesNotGeneratePDF() {
        // Arrange — StickerViewModel recém-criado, nenhuma geração solicitada

        // Act — (nenhuma ação)

        // Assert
        XCTAssertNil(sut.getDoc(), "getDoc deve retornar nil antes de generatePDF ser chamado.")
        XCTAssertNil(sut.getView(), "getView deve retornar nil antes de generatePDF ser chamado.")
        XCTAssertEqual(spy.generatePDFCallCount, 0, "generatePDF não deve ser chamado no init.")
    }

    // MARK: - T06 — RN06 — Geração delega ao PDFManager

    @MainActor
    func test_GeneratePDF_DelegatesToPDFManager() {
        // Arrange
        let expectedQuantity = 5

        // Act
        sut.generatePDF(stickerQuantity: expectedQuantity)

        // Assert
        XCTAssertEqual(spy.generatePDFCallCount, 1, "generatePDF do manager deve ser chamado exatamente uma vez.")
        XCTAssertEqual(spy.lastQuantity, expectedQuantity, "Quantidade passada ao manager deve ser \(expectedQuantity).")
    }
    
    @MainActor
    func test_GetDoc_AfterGenerate_ReturnsCustomPDFDoc() {
        // Arrange
        spy.stubbedData = Data([0x25, 0x50, 0x44, 0x46]) // bytes mínimos não-nil

        // Act
        sut.generatePDF(stickerQuantity: 1)
        let doc = sut.getDoc()

        // Assert
        XCTAssertNotNil(doc, "getDoc deve retornar CustomPDFDoc não-nil quando PDFManager retorna Data.")
    }

    @MainActor
    func test_GetDoc_WhenPDFDataNil_ReturnsNil() {
        // Arrange — spy retorna nil (ex: asset não encontrado no bundle)
        spy.stubbedData = nil

        // Act
        sut.generatePDF(stickerQuantity: 1)
        let doc = sut.getDoc()

        // Assert
        XCTAssertNil(doc, "getDoc deve retornar nil quando PDFManager retorna nil.")
    }

    @MainActor
    func test_GetView_WhenDocumentNil_ReturnsNil() {
        // Arrange — spy retorna nil; pdfDocument nunca é criado
        spy.stubbedData = nil
        sut.generatePDF(stickerQuantity: 1)

        // Act
        let view = sut.getView()

        // Assert
        XCTAssertNil(view, "getView deve retornar nil quando pdfDocument é nil.")
    }

    @MainActor
    func test_GetView_AfterGenerate_WithValidPDF_ReturnsPDFKitView() {
        // Arrange — PDF válido gerado pelo renderer de teste (independente do asset 'sticker')
        spy.stubbedData = makeValidPDFData()
        sut.generatePDF(stickerQuantity: 1)

        // Act
        let view = sut.getView()

        // Assert
        XCTAssertNotNil(view, "getView deve retornar PDFKitView quando pdfDocument é válido.")
    }

    @MainActor
    func test_GeneratePDF_CalledMultipleTimes_UsesLastData() {
        // Arrange — primeira geração com data válida
        spy.stubbedData = makeValidPDFData()
        sut.generatePDF(stickerQuantity: 1)
        XCTAssertNotNil(sut.getDoc(), "Pré-condição: primeira geração deve produzir doc.")

        // Act — segunda geração com spy retornando nil
        spy.stubbedData = nil
        sut.generatePDF(stickerQuantity: 2)

        // Assert — estado deve refletir a segunda chamada
        XCTAssertNil(sut.getDoc(), "Após segunda geração com nil, getDoc deve retornar nil.")
        XCTAssertEqual(spy.generatePDFCallCount, 2, "generatePDF deve ter sido chamado duas vezes.")
    }
}

// MARK: - Helpers

private extension StickerViewModelTests {

    /// Gera PDF válido via UIGraphicsPDFRenderer, sem depender do asset 'sticker'.
    func makeValidPDFData() -> Data {
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 100, height: 100))
        return renderer.pdfData { context in context.beginPage() }
    }
}
