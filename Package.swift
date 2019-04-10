// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "GEOSwift",
  products: [
    .library(name: "GEOSwift", targets: ["GEOSwift"])
  ],
  dependencies: [],
  targets: [
    .target(
      name: "GEOSwift",
      dependencies: ["CLibGeosC"],
      path: "./GEOSwift/"
    ),
    .testTarget(
      name: "GEOSwiftTests",
      dependencies: ["GEOSwift"],
      path: "./GEOSwiftTests/"
    ),
    .systemLibrary(
      name: "CLibGeosC",
      path: "./CLibGeosC",
      pkgConfig: "geos_c",
      providers: [
        .brew(["geos"]),
        .apt(["libgeos-3.6.2"])
      ]
    )
  ]
)
