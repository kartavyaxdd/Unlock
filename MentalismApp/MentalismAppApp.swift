import SwiftUI

@main
struct MentalismAppApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var appModel = AppModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appModel)
                .overlay {
                    if appModel.shouldHideForPrivacy {
                        SanitizedOverlayView()
                    }
                }
                .onChange(of: scenePhase) { newPhase in
                    appModel.handleScenePhaseChange(newPhase)
                }
        }
    }
}
