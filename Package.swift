// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "AnthropicSwiftSDK",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AnthropicSwiftSDK",
            targets: ["AnthropicSwiftSDK"]),
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint", .upToNextMajor(from: "0.54.0")),
        .package(url: "https://github.com/apple/swift-syntax", .upToNextMajor(from: "509.0.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AnthropicSwiftSDK",
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]),
        .testTarget(
            name: "AnthropicSwiftSDKTests",
            dependencies: ["AnthropicSwiftSDK"]),
        .macro(
            name: "AnthropicCallableFunction",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                "AnthropicSwiftSDK"]),
        .target(
            name: "AnthropicCallableFunctions",
            dependencies: [
                "AnthropicCallableFunction"]),
    ]
)
