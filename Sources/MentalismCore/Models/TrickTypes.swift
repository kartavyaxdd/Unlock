import Foundation

public enum RevealMode: String, CaseIterable, Codable, Sendable, Identifiable {
    case audio

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .audio:
            return "Audio"
        }
    }
}

public enum MaskingBehavior: String, Codable, Sendable {
    case maskedDots
    case lastDigitVisible
}

public struct SecretInputSpec: Codable, Equatable, Sendable {
    public let digitCount: Int
    public let allowedCharacters: Set<Character>
    public let maskingBehavior: MaskingBehavior

    public init(
        digitCount: Int,
        allowedCharacters: Set<Character> = Set("0123456789"),
        maskingBehavior: MaskingBehavior = .maskedDots
    ) {
        self.digitCount = digitCount
        self.allowedCharacters = allowedCharacters
        self.maskingBehavior = maskingBehavior
    }

    public func accepts(_ character: Character) -> Bool {
        allowedCharacters.contains(character)
    }

    public func validate(_ secret: String) -> Bool {
        guard secret.count == digitCount else { return false }
        return secret.allSatisfy { accepts($0) }
    }
}

public struct TrickDefinition: Codable, Equatable, Sendable, Identifiable {
    public let id: String
    public let displayName: String
    public let supportedRevealModes: [RevealMode]
    public let inputConstraints: SecretInputSpec

    public init(
        id: String,
        displayName: String,
        supportedRevealModes: [RevealMode],
        inputConstraints: SecretInputSpec
    ) {
        self.id = id
        self.displayName = displayName
        self.supportedRevealModes = supportedRevealModes
        self.inputConstraints = inputConstraints
    }

    public static func passcodePeek(digitCount: Int = 4) -> TrickDefinition {
        TrickDefinition(
            id: "passcode-peek",
            displayName: "Passcode Peek",
            supportedRevealModes: [.audio],
            inputConstraints: SecretInputSpec(digitCount: digitCount)
        )
    }
}

public enum TrickSessionStatus: String, Codable, Equatable, Sendable {
    case idle
    case collecting
    case captured
    case revealing
    case neutralized
}

public struct ActiveTrickSession: Codable, Equatable, Sendable {
    public let trickId: String
    public var status: TrickSessionStatus
    public var enteredSecret: String
    public var revealMode: RevealMode
    public let createdAt: Date

    public init(
        trickId: String,
        status: TrickSessionStatus,
        enteredSecret: String,
        revealMode: RevealMode,
        createdAt: Date = Date()
    ) {
        self.trickId = trickId
        self.status = status
        self.enteredSecret = enteredSecret
        self.revealMode = revealMode
        self.createdAt = createdAt
    }
}

public struct PrivacyPolicyState: Codable, Equatable, Sendable {
    public let acceptedVersion: String
    public let acceptedAt: Date

    public init(acceptedVersion: String, acceptedAt: Date = Date()) {
        self.acceptedVersion = acceptedVersion
        self.acceptedAt = acceptedAt
    }
}
