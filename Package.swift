// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "GEOSwift",
    platforms: [.iOS(.v16), .macOS(.v13), .tvOS(.v16), .watchOS(.v9), .visionOS(.v1)],
    products: [
        .library(name: "GEOSwift", targets: ["GEOSwift"])
    ],
    dependencies: [
        .package(url: "https://github.com/GEOSwift/geos.git", from: "11.0.0")
    ],
    targets: [
        .target(
            name: "GEOSwift",
            dependencies: ["geos"]
        ),
        .testTarget(
            name: "GEOSwiftTests",
            dependencies: ["GEOSwift"]
        )
    ]
)
