import SwiftUI

struct SpectatorEntryView: View {
    @EnvironmentObject private var appModel: AppModel
    @State private var showPerformerControls = false

    private let keypadRows = [
        ["1", "2", "3"],
        ["4", "5", "6"],
        ["7", "8", "9"],
        ["", "0", "⌫"],
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.02, green: 0.04, blue: 0.08), Color(red: 0.08, green: 0.14, blue: 0.20)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                VStack(spacing: 10) {
                    Text("Signal Vault")
                        .font(.system(size: 30, weight: .semibold, design: .rounded))
                        .onLongPressGesture(minimumDuration: 1.5) {
                            showPerformerControls = true
                        }
                    Text("Enter your verification code")
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 14) {
                    ForEach(0..<appModel.activeDigitCount, id: \.self) { index in
                        Circle()
                            .fill(index < appModel.enteredDigitCount ? Color.orange : Color.white.opacity(0.18))
                            .frame(width: 18, height: 18)
                    }
                }
                .accessibilityIdentifier("digit-indicators")

                VStack(spacing: 14) {
                    ForEach(keypadRows, id: \.self) { row in
                        HStack(spacing: 14) {
                            ForEach(row, id: \.self) { key in
                                keypadButton(for: key)
                            }
                        }
                    }
                }

                Text("Protected input active")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding(24)
        }
        .confirmationDialog("Performer Controls", isPresented: $showPerformerControls, titleVisibility: .visible) {
            Button("Panic Reset", role: .destructive) {
                appModel.panicReset()
            }
        } message: {
            Text("Reset immediately and clear the active routine.")
        }
    }

    @ViewBuilder
    private func keypadButton(for key: String) -> some View {
        if key.isEmpty {
            Color.clear
                .frame(width: 88, height: 88)
        } else {
            Button {
                if key == "⌫" {
                    appModel.removeLastDigit()
                } else if let character = key.first {
                    appModel.appendDigit(character)
                }
            } label: {
                Text(key)
                    .font(.system(size: 28, weight: .medium, design: .rounded))
                    .frame(width: 88, height: 88)
                    .background(.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 28, style: .continuous))
            }
            .buttonStyle(.plain)
            .foregroundStyle(.white)
            .accessibilityIdentifier(key == "⌫" ? "delete-button" : "digit-\(key)")
        }
    }
}
