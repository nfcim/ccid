// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ccid",
    platforms: [
        .iOS("12.0"),
        .macOS("10.14")
    ],
    products: [
        .library(name: "ccid", targets: ["ccid"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ccid",
            dependencies: [],
            resources: [
            ]
        )
    ]
)