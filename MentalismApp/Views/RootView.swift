import SwiftUI

struct RootView: View {
    @AppStorage("privacyPolicyAcceptedVersion") private var acceptedVersion = ""
    @EnvironmentObject private var appModel: AppModel

    private let currentPrivacyVersion = "1.0"

    var body: some View {
        Group {
            if acceptedVersion != currentPrivacyVersion {
                OnboardingView(currentPrivacyVersion: currentPrivacyVersion) {
                    acceptedVersion = currentPrivacyVersion
                }
            } else {
                switch appModel.route {
                case .home:
                    TrickSelectionView()
                case .spectatorInput:
                    SpectatorEntryView()
                case .neutralized:
                    NeutralizedView()
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
