// swift-tools-version:5.1
import PackageDescription

let package = Package(
  name: "GEOSwift",
  products: [
    .library(name: "GEOSwift", targets: ["GEOSwift"])
  ],
  dependencies: [
    .package(url: "https://github.com/GEOSwift/geos.git", from: "4.1.0")
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
