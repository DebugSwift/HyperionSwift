// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "HyperionSwift",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "HyperionSwift",
            targets: ["HyperionSwift"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "HyperionSwift",
            dependencies: [],
            path: "HyperionSwift",
            swiftSettings: [
                .enableExperimentalFeature("StrictConcurrency")
            ]
        )
    ],
    swiftLanguageModes: [.v6]
)
