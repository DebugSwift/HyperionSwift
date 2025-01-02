// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "HyperionSwift",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
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
            resources: [
                .process("Resources")
            ]
        )
    ],
    swiftLanguageVersions: [.v5]
)