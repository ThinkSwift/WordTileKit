// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "WordTileKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "WordTileKit",
            targets: ["WordTileKit"]
        )
    ],
    targets: [
        .target(
            name: "WordTileKit",
            path: "Sources/WordTileKit"
        ),
        .testTarget(
            name: "WordTileKitTests",
            dependencies: ["WordTileKit"],
            path: "Tests/WordTileKitTests"
        )
    ]
)