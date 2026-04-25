import SwiftUI
import MentalismCore

@MainActor
final class AppModel: ObservableObject {
    enum Route: Equatable {
        case home
        case spectatorInput
        case neutralized
    }

    @Published var route: Route = .home
    @Published var digitCount: Int = 4
    @Published var selectedRevealMode: RevealMode = .audio
    @Published var performerMessage: String = "Choose the digit length, then hand the phone over."
    @Published var shouldHideForPrivacy = false

    private let store = TrickSessionStore()
    private lazy var audioService = AudioRevealService()
    private lazy var engine = PasscodePeekEngine(
        store: store,
        router: DefaultRevealRouter(performers: [audioService])
    )
    private lazy var resetService = DefaultResetService(store: store)

    var maskedEntry: String {
        engine.maskedSecret
    }

    var enteredDigitCount: Int {
        store.activeSession?.enteredSecret.count ?? 0
    }

    var activeDigitCount: Int {
        engine.definition.inputConstraints.digitCount
    }

    var isReadyToReveal: Bool {
        engine.isReadyToReveal
    }

    var sessionStatusText: String {
        guard let session = store.activeSession else { return "Idle" }
        switch session.status {
        case .idle:
            return "Idle"
        case .collecting:
            return "Collecting"
        case .captured:
            return "Captured"
        case .revealing:
            return "Revealing"
        case .neutralized:
            return "Neutralized"
        }
    }

    func beginRoutine() {
        _ = engine.startSession(revealMode: selectedRevealMode, digitCount: digitCount)
        performerMessage = "Spectator mode is active."
        route = .spectatorInput
    }

    func appendDigit(_ digit: Character) {
        objectWillChange.send()
        engine.appendDigit(digit)
        guard isReadyToReveal else { return }

        Task {
            let outcome = await engine.reveal()
            switch outcome {
            case .delivered:
                performerMessage = "Secret delivered through audio."
            case .fallback(let message):
                performerMessage = message
            }
            route = .neutralized
        }
    }

    func removeLastDigit() {
        objectWillChange.send()
        engine.removeLastDigit()
    }

    func panicReset() {
        resetService.reset()
        performerMessage = "Routine reset. No secret retained."
        shouldHideForPrivacy = false
        route = .home
    }

    func handleScenePhaseChange(_ phase: ScenePhase) {
        shouldHideForPrivacy = phase != .active && store.hasActiveSecret
    }
}
