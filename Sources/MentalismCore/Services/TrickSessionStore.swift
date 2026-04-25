import Foundation

public final class TrickSessionStore {
    public private(set) var activeSession: ActiveTrickSession?

    public init(activeSession: ActiveTrickSession? = nil) {
        self.activeSession = activeSession
    }

    @discardableResult
    public func startSession(
        definition: TrickDefinition,
        revealMode: RevealMode
    ) -> ActiveTrickSession {
        let session = ActiveTrickSession(
            trickId: definition.id,
            status: .collecting,
            enteredSecret: "",
            revealMode: revealMode
        )
        activeSession = session
        return session
    }

    public func updateSecret(_ secret: String) {
        activeSession?.enteredSecret = secret
    }

    public func updateStatus(_ status: TrickSessionStatus) {
        activeSession?.status = status
    }

    public var hasActiveSecret: Bool {
        guard let activeSession else { return false }
        return !activeSession.enteredSecret.isEmpty
    }

    public func clear() {
        activeSession = nil
    }
}
