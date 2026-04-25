import AVFoundation
import MentalismCore

final class AudioRevealService: NSObject, SecretRevealPerformer {
    let mode: RevealMode = .audio
    private let synthesizer = AVSpeechSynthesizer()

    var isAvailable: Bool {
        true
    }

    func perform(secret: String) async -> Bool {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers, .allowBluetooth, .allowAirPlay])
            try session.setActive(true)
        } catch {
            return false
        }

        let utterance = AVSpeechUtterance(string: secret.map(String.init).joined(separator: " "))
        utterance.rate = 0.38
        utterance.prefersAssistiveTechnologySettings = true
        synthesizer.speak(utterance)
        return true
    }
}
