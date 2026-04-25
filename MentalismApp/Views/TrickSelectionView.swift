import SwiftUI
import MentalismCore

struct TrickSelectionView: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [Color(red: 0.05, green: 0.08, blue: 0.13), Color(red: 0.16, green: 0.11, blue: 0.06)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Passcode Peek")
                            .font(.largeTitle.bold())
                        Text("A premium keypad-based mentalism routine for voluntary spectator input and performer-only audio reveal.")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    settingsCard

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Performer notes")
                            .font(.headline)
                        Text("Use only with willing spectators. This routine stays inside the app's own interface and is designed for private/TestFlight distribution.")
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer()

                    Button("Start Spectator Mode") {
                        appModel.beginRoutine()
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.orange)
                    .controlSize(.large)
                }
                .padding(24)
            }
        }
    }

    private var settingsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Routine setup")
                .font(.headline)

            Picker("Digits", selection: $appModel.digitCount) {
                Text("4-digit").tag(4)
                Text("6-digit").tag(6)
            }
            .pickerStyle(.segmented)

            Picker("Reveal mode", selection: $appModel.selectedRevealMode) {
                ForEach(RevealMode.allCases) { mode in
                    Text(mode.displayName).tag(mode)
                }
            }
            .pickerStyle(.segmented)
            .disabled(true)

            Text(appModel.performerMessage)
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}
