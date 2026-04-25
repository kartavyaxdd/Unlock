import Foundation

public enum RevealExecutionOutcome: Equatable, Sendable {
    case delivered(mode: RevealMode)
    case fallback(message: String)
}

public protocol SecretRevealPerformer {
    var mode: RevealMode { get }
    var isAvailable: Bool { get }
    func perform(secret: String) async -> Bool
}

public final class DefaultRevealRouter {
    private let performers: [RevealMode: any SecretRevealPerformer]

    public init(performers: [any SecretRevealPerformer]) {
        self.performers = Dictionary(uniqueKeysWithValues: performers.map { ($0.mode, $0) })
    }

    public func route(secret: String, preferredMode: RevealMode) async -> RevealExecutionOutcome {
        if let preferred = performers[preferredMode], preferred.isAvailable {
            let delivered = await preferred.perform(secret: secret)
            if delivered {
                return .delivered(mode: preferredMode)
            }
        }

        let fallbackModes = RevealMode.allCases.filter { $0 != preferredMode }
        for mode in fallbackModes {
            guard let performer = performers[mode], performer.isAvailable else {
                continue
            }
            let delivered = await performer.perform(secret: secret)
            if delivered {
                return .delivered(mode: mode)
            }
        }

        return .fallback(
            message: fallbackMessage(for: preferredMode)
        )
    }

    private func fallbackMessage(for preferredMode: RevealMode) -> String {
        switch preferredMode {
        case .audio:
            return "Audio reveal unavailable. Keep the phone private, reset the routine, and reconnect an audio route before the next performance."
        }
    }
}
