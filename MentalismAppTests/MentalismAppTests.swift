import XCTest
@testable import MentalismApp

final class MentalismAppTests: XCTestCase {
    @MainActor
    func testPanicResetReturnsToHome() {
        let model = AppModel()
        model.beginRoutine()

        model.panicReset()

        XCTAssertEqual(model.route, .home)
        XCTAssertEqual(model.performerMessage, "Routine reset. No secret retained.")
    }
}
