// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "UTMConversion",
    platforms: [
        .iOS(.v12), .macOS(.v10_10)
    ],
    products: [
        .library(
            name: "UTMConversion",
            targets: ["UTMConversion"]),
    ],
    targets: [
        .target(
            name: "UTMConversion",
            dependencies: [],
            path: "UTMConversion"),
        .testTarget(
            name: "UTMConversionTests",
            dependencies: ["UTMConversion"],
            path: "UTMConversionTests"),
    ]
)
