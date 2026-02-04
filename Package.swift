// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MacHardwareInfoCLI",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.28.0")
    ],
    targets: [
        .executableTarget(
            name: "MacHardwareInfoCLI",
            dependencies: [
                .product(name: "SwiftProtobuf", package: "swift-protobuf")
            ]
        ),
        .testTarget(
            name: "MacHardwareInfoCLITests",
            dependencies: [
                "MacHardwareInfoCLI",
                .product(name: "SwiftProtobuf", package: "swift-protobuf")
            ]
        )
    ]
)
