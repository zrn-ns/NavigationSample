// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "DocGenerator",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "DocGenerator",
            path: "Sources"
        ),
    ]
)
