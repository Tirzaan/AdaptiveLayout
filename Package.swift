// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "AdaptiveLayout",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .macCatalyst(.v16)
    ],
    products: [
        .library(
            name: "AdaptiveLayout",
            targets: ["AdaptiveLayout"]
        ),
    ],
    targets: [
        .target(
            name: "AdaptiveLayout",
            path: "Sources/AdaptiveLayout"
        ),
    ]
)
