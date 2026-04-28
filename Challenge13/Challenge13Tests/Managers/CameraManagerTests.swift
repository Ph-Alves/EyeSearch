//
//  CameraManagerTests.swift
//  EyeSearchTests
//
//  Created by Manoel Pedro Prado Sa Teles on 22/04/26.
//

import XCTest
import AVFoundation
@testable import EyeSearch

// MARK: - Spy

/// Spy de CameraManagerDelegate para capturar as chamadas de forwarding de buffer.
private final class CameraManagerDelegateSpy: CameraManagerDelegate {
    private(set) var didCaptureCalled = false
    private(set) var capturedBuffer: CMSampleBuffer?
    private(set) var capturedManager: CameraManaging?

    func cameraManager(_ manager: CameraManaging, didCapture sampleBuffer: CMSampleBuffer) {
        didCaptureCalled = true
        capturedBuffer = sampleBuffer
        capturedManager = manager
    }
}

// MARK: - Test Suite

@MainActor
final class CameraManagerTests: XCTestCase {

    // MARK: Inviáveis — do documento
    //
    // T11 RN15 — Lanterna automática ao abrir busca
    //   Débito de funcionalidade: CameraManager não controla AVCaptureDevice.torchMode.
    //   Proposta: implementar toggleTorch(_ on: Bool) usando AVCaptureDevice.default(for: .video)
    //   e expor estado via isTorchActive: Bool.
    //
    // T12 RN15 — Indicador visual da lanterna
    //  UI test: verificação de estado de UI, fora do escopo de unit tests.
    //
    // T14 RN17 — Reconhecimento em até 3 segundos sem travar
    //   Performance/UI test: exige hardware real, câmera ativa e medição ponta a ponta.
    //
    // T_Denied — Testar o caminho .denied / .restricted de checkAuthorization
    //   AVCaptureDevice.authorizationStatus não é injetável sem refactor do CameraManager.
    //   Proposta: extrair um closure `authorizationStatusProvider: () -> AVAuthorizationStatus`
    //   no init para permitir stubbing e cobrir os ramos isDenied = true / isAuthorized = false.
    //
    // T_HappyPath — Testar isAuthorized = true / isDenied = false
    //   O simulador nega o acesso à câmera automaticamente no ambiente de testes.
    //   Os ramos .authorized e .notDetermined → granted não são atingíveis sem DI ou dispositivo real.

    // MARK: - Propriedades

    private var sut: CameraManager!

    // MARK: - Setup / Teardown

    override func setUp() {
        super.setUp()
        sut = CameraManager()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    // MARK: - checkAuthorization


    // MARK: - Additional coverage

    func test_IsAuthorized_InitiallyFalse() {
        // Arrange — CameraManager recém-criado, checkAuthorization não chamado
        // Act — (nenhuma ação; apenas leitura do estado inicial)
        XCTAssertFalse(
            sut.isAuthorized,
            "isAuthorized deve ser false antes de qualquer chamada a checkAuthorization."
        )
    }

    func test_IsDenied_InitiallyFalse() {
        // Arrange — CameraManager recém-criado, checkAuthorization não chamado
        // Act — (nenhuma ação; apenas leitura do estado inicial)
        XCTAssertFalse(
            sut.isDenied,
            "isDenied deve ser false antes de qualquer chamada a checkAuthorization."
        )
    }

    func test_Session_InitiallyEmpty() {
        // Arrange — CameraManager recém-criado, setupSession não chamado
        // Act — (nenhuma ação; apenas leitura do estado inicial)
        XCTAssertTrue(
            sut.session.inputs.isEmpty,
            "session não deve ter inputs antes de setupSession ser chamado."
        )
        XCTAssertTrue(
            sut.session.outputs.isEmpty,
            "session não deve ter outputs antes de setupSession ser chamado."
        )
    }

    func test_Stop_DoesNotCrash() {
        // Arrange — session não iniciada (simulador não tem câmera real)

        // Act & Assert — session.stopRunning() em sessão não configurada deve ser noop seguro
        XCTAssertNoThrow(sut.stop(), "stop() antes de setupSession não deve crashar.")
    }

    func test_Stop_CalledMultipleTimes_DoesNotCrash() {
        // Arrange — primeira chamada coloca o estado em "parado"
        sut.stop()

        // Act & Assert — segunda chamada em sessão já parada é noop seguro
        XCTAssertNoThrow(sut.stop(), "stop() chamado múltiplas vezes não deve crashar.")
    }

    func test_SetTorch_WithoutDevice_DoesNotCrash() {
        // Arrange — device é nil antes de setupSession (não há hardware no simulador)
        // guard let device, device.hasTorch (linha 52) deve retornar silenciosamente

        // Act & Assert
        XCTAssertNoThrow(
            sut.setTorch(on: true),
            "setTorch antes de setupSession não deve crashar quando device é nil."
        )
        XCTAssertNoThrow(
            sut.setTorch(on: false),
            "setTorch(on: false) antes de setupSession não deve crashar."
        )
    }

    func test_CaptureOutput_ForwardsBufferToDelegate() throws {
        // Arrange
        let spy = CameraManagerDelegateSpy()
        sut.delegate = spy

        let sampleBuffer = try makeSampleBuffer()

        // AVCaptureConnection stub: inputPorts vazio é aceito pelo inicializador público.
        // O parâmetro `connection` não é lido dentro de captureOutput — workaround legítimo.
        let output = AVCaptureVideoDataOutput()
        let connection = AVCaptureConnection(inputPorts: [], output: output)

        // Act
        sut.captureOutput(output, didOutput: sampleBuffer, from: connection)

        // Assert
        XCTAssertTrue(
            spy.didCaptureCalled,
            "captureOutput deve acionar cameraManager(_:didCapture:) no delegate."
        )
        XCTAssertNotNil(
            spy.capturedBuffer,
            "O delegate deve receber um CMSampleBuffer não-nil."
        )
        XCTAssertTrue(
            spy.capturedManager === sut,
            "O manager repassado ao delegate deve ser a própria instância do CameraManager."
        )
    }
}

// MARK: - Helpers

private extension CameraManagerTests {

    /// Constrói um CMSampleBuffer mínimo (1×1 px) adequado para testes unitários.
    /// Usa XCTSkip se o ambiente de simulador não suportar a criação dos objetos CoreMedia.
    func makeSampleBuffer() throws -> CMSampleBuffer {
        // 1. CVPixelBuffer 1×1 para servir de imageBuffer
        var pixelBuffer: CVPixelBuffer?
        let pixelStatus = CVPixelBufferCreate(
            kCFAllocatorDefault,
            1, 1,
            kCVPixelFormatType_32BGRA,
            nil,
            &pixelBuffer
        )
        guard pixelStatus == kCVReturnSuccess, let pixelBuffer else {
            throw XCTSkip("Ambiente de teste não suporta criação de CVPixelBuffer.")
        }

        // 2. CMFormatDescription derivada do pixelBuffer
        var formatDescription: CMFormatDescription?
        CMVideoFormatDescriptionCreateForImageBuffer(
            allocator: kCFAllocatorDefault,
            imageBuffer: pixelBuffer,
            formatDescriptionOut: &formatDescription
        )
        guard let formatDescription else {
            throw XCTSkip("Ambiente de teste não suporta criação de CMFormatDescription.")
        }

        // 3. CMSampleBuffer pronto (ready) com timestamps nulos — conteúdo irrelevante para o teste
        var timingInfo = CMSampleTimingInfo(
            duration: .invalid,
            presentationTimeStamp: .zero,
            decodeTimeStamp: .invalid
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

