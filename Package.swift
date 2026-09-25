// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ADUtilities",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ADUtilities",
            targets: ["ADUtilities"]
        )
    ],
    targets: [
        .target(
            name: "ADUtilities"
        ),
        .testTarget(
            name: "ADUtilitiesTests",
            dependencies: ["ADUtilities"]
        ),
    ],
    // Tools 6.4 defaults to Swift 6 mode; 0085 moves this package to it.
    swiftLanguageModes: [.v5]
)
