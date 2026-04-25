import XCTest

final class MentalismAppUITests: XCTestCase {
    func testOnboardingGateAndSpectatorFlow() {
        let app = XCUIApplication()
        app.launchArguments = ["UITesting"]
        app.launch()

        if app.buttons["I Understand and Accept"].exists {
            app.buttons["I Understand and Accept"].tap()
        }

        XCTAssertTrue(app.buttons["Start Spectator Mode"].exists)
        app.buttons["Start Spectator Mode"].tap()

        XCTAssertTrue(app.otherElements["digit-indicators"].exists)
        XCTAssertTrue(app.buttons["digit-1"].exists)
        XCTAssertTrue(app.buttons["delete-button"].exists)
    }
}
