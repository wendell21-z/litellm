// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "LiteLLMProxyApp",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "LiteLLMProxyApp", targets: ["LiteLLMProxyApp"])
    ],
    targets: [
        .executableTarget(
            name: "LiteLLMProxyApp",
            path: "Sources/LiteLLMProxyApp"
        ),
        .testTarget(
            name: "LiteLLMProxyAppTests",
            dependencies: ["LiteLLMProxyApp"],
            path: "Tests/LiteLLMProxyAppTests"
        )
    ]
)
