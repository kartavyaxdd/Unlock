// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MentalismCore",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
    ],
    products: [
        .library(
            name: "MentalismCore",
            targets: ["MentalismCore"]
        ),
    ],
    targets: [
        .target(
            name: "MentalismCore",
            path: "Sources/MentalismCore"
        ),
        .testTarget(
            name: "MentalismCoreTests",
            dependencies: ["MentalismCore"],
            path: "Tests/MentalismCoreTests"
        ),
    ]
)
