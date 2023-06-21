// swift-tools-version:5.7

import PackageDescription

let package = Package(
  name: "swift-composable-architecture-Synchronize-state",
  platforms: [
    .iOS(.v13),
    .macOS(.v10_15),
    .tvOS(.v13),
    .watchOS(.v6),
  ],
  products: [
    .library(
      name: "SynchronizeStateTCA",
      targets: ["SynchronizeStateTCA"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "0.54.1"),
  ],
  targets: [
    .target(
      name: "SynchronizeStateTCA",
      dependencies: [
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
      ]
    ),
    .testTarget(
      name: "SynchronizeStateTCATests",
      dependencies: [
        "SynchronizeStateTCA"
      ]
    ),
  ]
)
