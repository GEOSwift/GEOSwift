![GEOSwift](/README-images/GEOSwift.png)

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/GEOSwift.svg)](https://cocoapods.org/pods/GEOSwift)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)
[![Supported Platforms](https://img.shields.io/cocoapods/p/GEOSwift.svg?style=flat)](https://github.com/GEOSwift/GEOSwift)
[![Build Status](https://img.shields.io/travis/GEOSwift/GEOSwift/main)](https://travis-ci.com/GEOSwift/GEOSwift)
[![Code Coverage](https://img.shields.io/codecov/c/github/GEOSwift/GEOSwift/main)](https://codecov.io/gh/GEOSwift/GEOSwift)

Easily handle a geometric object model (points, linestrings, polygons etc.) and
related topological operations (intersections, overlapping etc.). A type-safe,
MIT-licensed Swift interface to the OSGeo's GEOS library routines.

> **For *MapKit* integration visit: https://github.com/GEOSwift/GEOSwiftMapKit**<br />
> **For *MapboxGL* integration visit: https://github.com/GEOSwift/GEOSwiftMapboxGL**<br />

## Migrating to Version 5 or Later

Version 5 constitutes a ground-up rewrite of GEOSwift. For full details and help
migrating from version 4, see [VERSION_5.md](VERSION_5.md).

## Features

* A pure-Swift, type-safe, optional-aware programming interface
* WKT and WKB reading & writing
* Robust support for *GeoJSON* via Codable
* Thread-safe
* Swift-native error handling
* Extensively tested

## Requirements

* iOS 9.0+, tvOS 9.0+, macOS 10.9+ (CocoaPods, Carthage, Swift PM)
* Linux (Swift PM)
* Swift 5.1

> GEOS is licensed under LGPL 2.1 and its compatibility with static linking is
at least controversial. Use of geos without dynamic linking is discouraged.

## Installation

### CocoaPods

1. Update your `Podfile` to include:

        use_frameworks!
        pod 'GEOSwift'

2. Run `$ pod install`

### Carthage

1. Add the following to your Cartfile:

        github "GEOSwift/GEOSwift" ~> 8.1

2. Finish updating your project by following the [typical Carthage
workflow](https://github.com/Carthage/Carthage#quick-start).

### Swift Package Manager

1. Update the top-level dependencies in your `Package.swift` to include:

        .package(url: "https://github.com/GEOSwift/GEOSwift.git", from: "8.1.0")

2. Update the target dependencies in your `Package.swift` to include

        "GEOSwift"

In certain cases, you may also need to explicitly include
[geos](https://github.com/GEOSwift/geos.git) as a dependency. See
[issue #195](https://github.com/GEOSwift/GEOSwift/issues/195) for details.

## Usage

### Geometry creation

```swift
// 1. From Well Known Text (WKT) representation
let point = try Point(wkt: "POINT(10 45)")
let polygon = try Geometry(wkt: "POLYGON((35 10, 45 45.5, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))")

// 2. From a Well Known Binary (WKB)
let wkb: NSData = geometryWKB()
let geometry2 = try Geometry(wkb: wkb)

// 3. From a GeoJSON file:
let decoder = JSONDecoder()
if let geoJSONURL = Bundle.main.url(forResource: "multipolygon", withExtension: "geojson"),
    let data = try? Data(contentsOf: geoJSONURL),
    let geoJSON = try? decoder.decode(GeoJSON.self, from: data),
    case let .feature(feature) = geoJSON,
    let italy = feature.geometry
{
    italy
}
```

### Topological operations

Let's say we have two geometries:

![Example geometries](/README-images/geometries.png)

GEOSwift let you perform a set of operations on these two geometries:

![Topological operations](/README-images/topological-operations.png)

### Predicates:

* _equals_: returns true if this geometric object is “spatially equal” to
  another geometry.
* _disjoint_: returns true if this geometric object is “spatially disjoint” from
  another geometry.
* _intersects_: returns true if this geometric object “spatially intersects”
  another geometry.
* _touches_: returns true if this geometric object “spatially touches” another
  geometry.
* _crosses_: returns true if this geometric object “spatially crosses’ another
  geometry.
* _within_: returns true if this geometric object is “spatially within” another
  geometry.
* _contains_: returns true if this geometric object “spatially contains” another
  geometry.
* _overlaps_: returns true if this geometric object “spatially overlaps” another
  geometry.
* _relate_: returns true if this geometric object is spatially related to
  another geometry by testing for intersections between the interior, boundary
  and exterior of the two geometric objects as specified by the values in the
  intersectionPatternMatrix.

### Playground

Explore more, interactively, in the playground, which is available in the
[GEOSwiftMapKit](https://github.com/GEOSwift/GEOSwiftMapKit) project. It can be
found inside `GEOSwiftMapKit` workspace. Open the workspace in Xcode, build the
`GEOSwiftMapKit` framework and open the playground file.

![Playground](/README-images/playground.png)

## Contributing

To make a contribution:

* Fork the repo
* Start from the `main` branch and create a branch with a name that describes
  your contribution
* Run `$ xed Package.swift` to open the project in Xcode.
* Run `$ swiftlint` from the repo root and resolve any issues.
* Update GEOSwift.xcodeproj: After making your changes, you also need to update
  the Xcode project. You'll need a version of Carthage greater than 0.36.0 so
  that you can use the `--use-xcframeworks` option. Run
  `$ carthage update --use-xcframeworks` to generate geos.xcframework. Then open
  the GEOSwift.xcodeproj and ensure that it works with your changes. You'll
  likely only need to make changes if you've added, removed, or renamed files.
* Sign in to travis-ci.com (if you've never signed in before, CI won't run to
  verify your pull request)
* Push your branch and create a pull request to `main`
* One of the maintainers will review your code and may request changes
* If your pull request is accepted, one of the maintainers should update the
  changelog before merging it

## Maintainer

* Andrew Hershberger ([@macdrevx](https://github.com/macdrevx))

## Past Maintainers

* Virgilio Favero Neto ([@vfn](https://github.com/vfn))
* Andrea Cremaschi ([@andreacremaschi](https://twitter.com/andreacremaschi))
  (original author)

## License

* GEOSwift was released by Andrea Cremaschi
  ([@andreacremaschi](https://twitter.com/andreacremaschi)) under a MIT license.
  See LICENSE for more information.
* [GEOS](http://trac.osgeo.org/geos/) stands for Geometry Engine - Open Source,
  and is a C++ library, ported from the
  [Java Topology Suite](http://sourceforge.net/projects/jts-topo-suite/).
  GEOS implements the OpenGIS
  [Simple Features for SQL](http://www.opengeospatial.org/standards/sfs) spatial
  predicate functions and spatial operators. GEOS, now an OSGeo project, was
  initially developed and maintained by
  [Refractions Research](http://www.refractions.net/) of Victoria, Canada.
