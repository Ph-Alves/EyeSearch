//
//  SearchObjectViewModelTests.swift
//  EyeSearchTests
//
//  Created by Manoel Pedro Prado Sa Teles on 24/04/26.
//

import XCTest
import AVFoundation
import CoreMedia
@testable import EyeSearch

// MARK: Débitos — do documento
//
// T01 RN02 — Borda verde ao reconhecer (detections não vazio)
// T03 RN04 — Haptics ao detectar sticker
// T04 RN05 — Som ao detectar sticker
// T11 RN15 — Lanterna via setFlashlight
// T18 RN20 — Confirmação encerra busca (confirmFound não implementado)
// T19 RN20 — Sem confirmação mantém busca ativa (idem)
// T26 RN27 — Objeto identificado e nome falado
//   Débito estrutural: SearchObjectViewModel.init recebe tipos concretos
//   (CameraManager, SoundManager, HapticsManager, MLModelManager, SettingsManager)
//   em vez dos protocolos correspondentes. Sem refatoração do init de produção,
//   não é possível injetar spies e verificar interações internas com os managers.

// MARK: - Test Suite

final class SearchObjectViewModelTests: XCTestCase {

    // MARK: - Propriedades

    private var sut: SearchObjectViewModel!

    // MARK: - Setup / Teardown

    override func setUp() {
        super.setUp()
        sut = SearchObjectViewModel(
            camera: CameraManager.shared,
            sound: SoundManager.shared,
            haptics: HapticsManager.shared,
            mlManager: MLModelManager.shared,
            settingsManager: SettingsManager.shared
        )
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - Estado inicial

    func test_ObjectsLabels_WithNoDetections_IsEmpty() {
        // Arrange — detections inicia como [] no init

        // Act — (nenhuma ação)

        // Assert
        XCTAssertTrue(sut.objectsLabels.isEmpty, "objectsLabels deve ser vazio quando não há detecções.")
    }

    func test_StickerCount_WithNoDetections_IsZero() {
        // Arrange

        // Act — (nenhuma ação)

        // Assert
        XCTAssertEqual(sut.stickerCount, 0, "stickerCount deve ser 0 quando não há detecções.")
    }

    func test_StickerOverlays_WithNoDetections_IsEmpty() {
        // Arrange

        // Act — (nenhuma ação)

        // Assert
        XCTAssertTrue(sut.stickerOverlays.isEmpty, "stickerOverlays deve ser vazio quando não há detecções.")
    }

    // MARK: - convertBoundingBox

    func test_ConvertBoundingBox_ReturnsExpectedRect() {
        // Arrange
        // Vision usa origem inferior-esquerda.
        // box (0.25, 0.50, 0.50, 0.25) em view 100×200 deve mapear para:
        //   x = 0.25 * 100 = 25
        //   y = (1 - 0.50 - 0.25) * 200 = 50
        //   w = 0.50 * 100 = 50
        //   h = 0.25 * 200 = 50
        let box      = CGRect(x: 0.25, y: 0.50, width: 0.50, height: 0.25)
        let viewSize = CGSize(width: 100, height: 200)

        // Act
        let result = sut.convertBoundingBox(box, in: viewSize)

        // Assert
        XCTAssertEqual(result.origin.x, 25,  accuracy: 0.001, "x deve ser 25.")
        XCTAssertEqual(result.origin.y, 50,  accuracy: 0.001, "y deve ser 50 (inversão do eixo Y do Vision).")
        XCTAssertEqual(result.width,    50,  accuracy: 0.001, "width deve ser 50.")
        XCTAssertEqual(result.height,   50,  accuracy: 0.001, "height deve ser 50.")
    }

    func test_ConvertBoundingBox_AtOrigin_ReturnsTopLeftInViewCoordinates() {
        // Arrange — box na origem do Vision (inferior-esquerdo) deve mapear para o fundo da view em UIKit
        let box      = CGRect(x: 0, y: 0, width: 0.10, height: 0.10)
        let viewSize = CGSize(width: 200, height: 200)

        // Act
        let result = sut.convertBoundingBox(box, in: viewSize)

        // Assert
        XCTAssertEqual(result.origin.x, 0,   accuracy: 0.001, "box na origem x deve mapear para 0.")
        XCTAssertEqual(result.origin.y, 180, accuracy: 0.001, "box na origem y (Vision) deve mapear para o fundo da view.")
    }

    // MARK: - stop

    func test_Stop_DoesNotCrash() {
        // Arrange — session não iniciada (simulador não tem câmera real)

        // Act & Assert
        XCTAssertNoThrow(sut.stop(), "stop() não deve crashar mesmo sem sessão de câmera ativa.")
    }

    func test_Stop_CalledMultipleTimes_DoesNotCrash() {
        // Arrange — primeira chamada para colocar o estado em "parado"
        sut.stop()

        // Act & Assert — session.stopRunning() em sessão já parada é noop seguro
        XCTAssertNoThrow(sut.stop(), "stop() chamado múltiplas vezes não deve crashar.")
    }

    // MARK: - cameraManager delegate

    func test_CameraDelegate_WhenCalled_DoesNotCrash() throws {
        // Arrange
        let camera = CameraManager.shared
        let buffer = try makeSampleBuffer()

        // Act & Assert
        // Se mlManager.isLoaded == false: guard retorna cedo — noop seguro.
        // Se mlManager.isLoaded == true:  detect(in:) pode lançar; catch interno swallows.
        // Em ambos os casos não deve crashar.
        XCTAssertNoThrow(
            sut.cameraManager(camera, didCapture: buffer),
            "cameraManager(_:didCapture:) não deve crashar independentemente do estado dos modelos."
        )
    }

    func test_CameraDelegate_CalledTwiceInSequence_DoesNotCrash() throws {
        // Arrange — a segunda chamada deve ser descartada pelo guard !isProcessing
        // enquanto a primeira ainda está em execução (ou já terminou — ambos são seguros)
        let camera = CameraManager.shared
        let buffer = try makeSampleBuffer()

        // Act & Assert
        XCTAssertNoThrow({
            sut.cameraManager(camera, didCapture: buffer)
            sut.cameraManager(camera, didCapture: buffer)
        }(), "Chamadas em sequência ao delegate não devem crashar.")
    }
}

// MARK: - Helpers

private extension SearchObjectViewModelTests {

    /// Constrói um CMSampleBuffer mínimo (1×1 px). Duplicado de CameraManagerTests
    /// pois não há pasta de mocks compartilhada (decisão arquitetural do projeto).
    func makeSampleBuffer() throws -> CMSampleBuffer {
        var pixelBuffer: CVPixelBuffer?
        let pixelStatus = CVPixelBufferCreate(
            kCFAllocatorDefault, 1, 1, kCVPixelFormatType_32BGRA, nil, &pixelBuffer
        )
        guard pixelStatus == kCVReturnSuccess, let pixelBuffer else {
            throw XCTSkip("Ambiente de teste não suporta criação de CVPixelBuffer.")
        }

        var formatDescription: CMFormatDescription?
        CMVideoFormatDescriptionCreateForImageBuffer(
            allocator: kCFAllocatorDefault,
            imageBuffer: pixelBuffer,
            formatDescriptionOut: &formatDescription
        )
        guard let formatDescription else {
            throw XCTSkip("Ambiente de teste não suporta criação de CMFormatDescription.")
        }

        var timingInfo = CMSampleTimingInfo(
            duration: .invalid, presentationTimeStamp: .zero, decodeTimeStamp: .invalid
        )
        var sampleBuffer: CMSampleBuffer?
        let sampleStatus = CMSampleBufferCreateReadyWithImageBuffer(
            allocator: kCFAllocatorDefault,
            imageBuffer: pixelBuffer,
            formatDescription: formatDescription,
            sampleTiming: &timingInfo,
            sampleBufferOut: &sampleBuffer
        )
        guard sampleStatus == noErr, let sampleBuffer else {
            throw XCTSkip("Ambiente de teste não suporta criação de CMSampleBuffer.")
        }
        return sampleBuffer
    }
}
