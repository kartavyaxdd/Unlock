import XCTest
@testable import MentalismCore

private final class MockPerformer: SecretRevealPerformer {
    let mode: RevealMode
    let isAvailable: Bool
    private(set) var deliveredSecrets: [String] = []

    init(mode: RevealMode, isAvailable: Bool) {
        self.mode = mode
        self.isAvailable = isAvailable
    }

    func perform(secret: String) async -> Bool {
        deliveredSecrets.append(secret)
        return true
    }
}

final class PasscodePeekEngineTests: XCTestCase {
    func testDigitCaptureSupportsFourDigitCode() {
        let audio = MockPerformer(mode: .audio, isAvailable: true)
        let engine = PasscodePeekEngine(
            router: DefaultRevealRouter(performers: [audio])
        )

        engine.startSession(revealMode: .audio, digitCount: 4)
        "1234".forEach(engine.appendDigit)

        XCTAssertTrue(engine.isReadyToReveal)
        XCTAssertEqual(engine.store.activeSession?.enteredSecret, "1234")
    }

    func testDigitCaptureSupportsSixDigitCode() {
        let audio = MockPerformer(mode: .audio, isAvailable: true)
        let engine = PasscodePeekEngine(
            router: DefaultRevealRouter(performers: [audio])
        )

        engine.startSession(revealMode: .audio, digitCount: 6)
        "654321".forEach(engine.appendDigit)

        XCTAssertTrue(engine.isReadyToReveal)
        XCTAssertEqual(engine.store.activeSession?.enteredSecret, "654321")
    }

    func testRevealRoutingUsesPreferredModeWhenAvailable() async {
        let audio = MockPerformer(mode: .audio, isAvailable: true)
        let engine = PasscodePeekEngine(
            router: DefaultRevealRouter(performers: [audio])
        )

        engine.startSession(revealMode: .audio, digitCount: 4)
        "1111".forEach(engine.appendDigit)
        let result = await engine.reveal()

        XCTAssertEqual(result, .delivered(mode: .audio))
        XCTAssertEqual(audio.deliveredSecrets, ["1111"])
    }

    func testResetClearsSecretBearingState() {
        let audio = MockPerformer(mode: .audio, isAvailable: true)
        let engine = PasscodePeekEngine(
            router: DefaultRevealRouter(performers: [audio])
        )

        engine.startSession(revealMode: .audio, digitCount: 4)
        "2468".forEach(engine.appendDigit)
        engine.panicReset()

        XCTAssertNil(engine.store.activeSession)
    }

    func testUnavailableAudioRevealReturnsSafeFallbackMessage() async {
        let audio = MockPerformer(mode: .audio, isAvailable: false)
        let engine = PasscodePeekEngine(
            router: DefaultRevealRouter(performers: [audio])
        )

        engine.startSession(revealMode: .audio, digitCount: 4)
        "8080".forEach(engine.appendDigit)
        let result = await engine.reveal()

        XCTAssertEqual(
            result,
            .fallback(
                message: "Audio reveal unavailable. Keep the phone private, reset the routine, and reconnect an audio route before the next performance."
            )
        )
    }
}
