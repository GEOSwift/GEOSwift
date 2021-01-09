// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "GEOSwift",
    platforms: [.iOS(.v9), .macOS("10.9"), .tvOS(.v9)],
    products: [
        .library(name: "GEOSwift", targets: ["GEOSwift"])
    ],
    dependencies: [
        .package(url: "https://github.com/GEOSwift/geos.git", from: "6.0.1")
    ],
    targets: [
        .target(
            name: "GEOSwift",
            dependencies: ["geos"],
            path: "./GEOSwift/"
        ),
        .testTarget(
            name: "GEOSwiftTests",
            dependencies: ["GEOSwift"],
            path: "./GEOSwiftTests/"
        )
    ]
)
