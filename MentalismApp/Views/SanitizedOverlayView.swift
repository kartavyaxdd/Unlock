import SwiftUI

struct SanitizedOverlayView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black, Color(red: 0.08, green: 0.08, blue: 0.10)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 12) {
                Image(systemName: "sparkles.rectangle.stack")
                    .font(.system(size: 42))
                    .foregroundStyle(.orange)
                Text("MentalismApp")
                    .font(.title2.bold())
                Text("Session hidden while inactive")
                    .foregroundStyle(.secondary)
            }
        }
    }
}
