import SwiftUI

struct NeutralizedView: View {
    @EnvironmentObject private var appModel: AppModel

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.03, green: 0.05, blue: 0.09), Color(red: 0.11, green: 0.09, blue: 0.06)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "waveform.path.ecg.rectangle")
                    .font(.system(size: 52))
                    .foregroundStyle(.orange)

                Text("Calibration complete")
                    .font(.title.bold())
                Text("The routine has moved into a neutral state. Prepare the next reveal when you're ready.")
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)

                Text(appModel.performerMessage)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Button("Reset for Next Performance") {
                    appModel.panicReset()
                }
                .buttonStyle(.borderedProminent)
                .tint(.orange)
            }
            .padding(24)
        }
    }
}
