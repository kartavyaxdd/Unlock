import Foundation

public final class PasscodePeekEngine {
    public let store: TrickSessionStore
    public private(set) var definition: TrickDefinition
    private let router: DefaultRevealRouter

    public init(
        definition: TrickDefinition = .passcodePeek(),
        store: TrickSessionStore = TrickSessionStore(),
        router: DefaultRevealRouter
    ) {
        self.definition = definition
        self.store = store
        self.router = router
    }

    @discardableResult
    public func startSession(
        revealMode: RevealMode,
        digitCount: Int
    ) -> ActiveTrickSession {
        definition = .passcodePeek(digitCount: digitCount)
        return store.startSession(definition: definition, revealMode: revealMode)
    }

    public func appendDigit(_ digit: Character) {
        guard definition.inputConstraints.accepts(digit) else { return }
        guard let session = store.activeSession, session.status == .collecting else { return }
        guard session.enteredSecret.count < definition.inputConstraints.digitCount else { return }

        let updated = session.enteredSecret + String(digit)
        store.updateSecret(updated)
        if updated.count == definition.inputConstraints.digitCount {
            store.updateStatus(.captured)
        }
    }

    public func removeLastDigit() {
        guard let session = store.activeSession else { return }
        guard !session.enteredSecret.isEmpty else { return }

        let updated = String(session.enteredSecret.dropLast())
        store.updateSecret(updated)
        store.updateStatus(updated.isEmpty ? .collecting : .collecting)
    }

    public var maskedSecret: String {
        let secret = store.activeSession?.enteredSecret ?? ""
        switch definition.inputConstraints.maskingBehavior {
        case .maskedDots:
            return String(repeating: "•", count: secret.count)
        case .lastDigitVisible:
            guard let last = secret.last else { return "" }
            return String(repeating: "•", count: max(secret.count - 1, 0)) + String(last)
        }
    }

    public var isReadyToReveal: Bool {
        guard let session = store.activeSession else { return false }
        return definition.inputConstraints.validate(session.enteredSecret)
    }

    public func reveal() async -> RevealExecutionOutcome {
        guard let session = store.activeSession else {
            return .fallback(message: "No active routine is available.")
        }
        guard definition.inputConstraints.validate(session.enteredSecret) else {
            return .fallback(message: "The entered code is incomplete.")
        }

        store.updateStatus(.revealing)
        let outcome = await router.route(
            secret: session.enteredSecret,
            preferredMode: session.revealMode
        )
        store.updateStatus(.neutralized)
        return outcome
    }

    public func panicReset() {
        store.clear()
    }
}
