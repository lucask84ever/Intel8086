// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Intel8086",
    targets: [
        .target(name: "Intel8086"),
        .testTarget(name: "Intel8086Tests", dependencies: ["Intel8086"])
    ]
)
