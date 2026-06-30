// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "AdaptiveLayout",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .tvOS(.v16),
        .watchOS(.v9),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "AdaptiveLayout",
            targets: ["AdaptiveLayout"]
        )
    ],
    targets: [
        .target(name: "AdaptiveLayout"),
        .testTarget(
            name: "AdaptiveLayoutTests",
            dependencies: ["AdaptiveLayout"]
        )
    ]
)
