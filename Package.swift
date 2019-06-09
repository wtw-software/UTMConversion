// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "UTMConversion",
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