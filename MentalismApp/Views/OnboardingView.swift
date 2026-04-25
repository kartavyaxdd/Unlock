import SwiftUI

struct OnboardingView: View {
    let currentPrivacyVersion: String
    let acknowledge: () -> Void

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color.black, Color(red: 0.08, green: 0.11, blue: 0.18)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("MentalismApp")
                            .font(.largeTitle.bold())
                        Text("Entertainment-only performance tool")
                            .foregroundStyle(.secondary)

                        disclosureCard(
                            title: "What this app does",
                            text: "It lets a spectator voluntarily enter a code into this app's own interface so the performer can reveal it through an illusion."
                        )
                        disclosureCard(
                            title: "What this app does not do",
                            text: "It does not read real phone passcodes, intercept system input, or access any other app."
                        )
                        disclosureCard(
                            title: "Data handling",
                            text: "Codes are intended to stay in memory during the active routine and should be cleared on reset or app termination."
                        )
                        disclosureCard(
                            title: "Performer output",
                            text: "v1 uses only iPhone audio playback for discreet performer feedback. No watch or network companion is included."
                        )

                        Button("I Understand and Accept") {
                            acknowledge()
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.orange)
                    }
                    .padding(24)
                }
            }
        }
    }

    private func disclosureCard(title: String, text: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(text)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}
