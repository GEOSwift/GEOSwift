![GEOSwift](/README-images/GEOSwift.png)

[![Swift Package Manager Compatible](https://img.shields.io/badge/SwiftPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)
[![Build Status](https://github.com/GEOSwift/GEOSwift/actions/workflows/main.yml/badge.svg)](https://github.com/GEOSwift/GEOSwift/actions/workflows/main.yml)

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
* Support for XY, XYZ, XYM, and XYZM geometries
* WKT and WKB reading & writing
* Robust support for *GeoJSON* via Codable
* Thread-safe
* Swift-native error handling
* Extensively tested

## Minimum Requirements

* iOS 16.0, tvOS 16.0, macOS 13.0, watchOS 9.0, visionOS 1.0, Linux
* Swift 5.9

> [!Note]
> GEOS is licensed under LGPL 2.1 and its compatibility with static linking is at least controversial. Use of geos without dynamic linking is discouraged.

## Installation

### Swift Package Manager

1. Update the top-level dependencies in your `Package.swift` to include:

        .package(url: "https://github.com/GEOSwift/GEOSwift.git", from: "11.2.0")

2. Update the target dependencies in your `Package.swift` to include

        "GEOSwift"

In certain cases, you may also need to explicitly include
[geos](https://github.com/GEOSwift/geos.git) as a dependency. See
[issue #195](https://github.com/GEOSwift/GEOSwift/issues/195) for details.

## Usage

### Geometry creation

```swift
// If you know the expected geometry coordinate types, you can decode directly from the Geometry<> type
let geometryXY = try Geometry<XY>(wkb: wkb) // All valid geometries will successfully decode as XY
let pointXY = try Point<XY>(wkt: "LINESTRING(35 10, 45 45.5)") // Fails since it is not a POINT
let pointXYZ = try Point<XYZ>(wkt: "POINT(10 45)") // Fails since the encoded geometry has no Z coordinate

// If you don't know the expected coordinate types of the encoded geometry, use a WKBReader/WKTReader
let anyGeometry = try WKBReader().readAny(wkb: wkb) // Returns an `AnyGeometry` enum that you can use to recover the coordinate and geometry types.
switch anyGeometry {
case .xyz(let geometry):
    doSomethingWith(geometry)
default:
    throw error
}

// or

let geometryXY = anyGeometry.asXY() // will always succeed
switch geometryXY {
case .point(let point):
    doSomethingWith(point)
default:
    throw error
}
```

#### From GeoJSON

```swift
// When decoding GeoJSON, you must explicitly declare the expected geometry coordinate type (e.g. GeoJSON<XY>)

let decoder = JSONDecoder()
if let geoJSONURL = Bundle.main.url(forResource: "multipolygon", withExtension: "geojson"),
    let data = try? Data(contentsOf: geoJSONURL),
    let geoJSON = try? decoder.decode(GeoJSON<XY>.self, from: data),
    case let .feature(feature) = geoJSON,
    let italy = feature.geometry
{
    italy
}
```

#### Initializing Geometry types directly

You can also initialize geometry types directly from coordinate types.

```swift
let pointXY = Point(x: 1, y: 2) // Equivalent to Point(XY(1, 2))
let lineStringXY = LineString(coordinates: [XYZ(1, 2, 3), XYZ(4, 5, 6)]) // CoordinateTypes must be consistent in one geometry
```

### Coordinate Dimensions

GEOSwift, like GEOS, supports geometry with 2 (`XY`), 3 (`XYZ`/`XYM`), and 4 (`XYZM`) coordinates. There are some important
things to know about using various coordinate types, mixing dimensionalities, and the impact on encoding/decoding
and geometric operations.

* The `XY` coordinate type is generally the safest and most intuitive. If you don't *need* Z/M, prefer keeping things 2D.
* With the exception of decoding, see below, you usually don't need to explicitly specialize the geometry to a specific
  `CoordinateType`. The dimensionality is infered from the initializer used (e.g. `Point(x: 1, y: 2)`, the base geometry 
  that you are composing with (e.g. `MultiLine`, `GeometryCollection`), or the result of a goemtric operation.
* When decoding geometry directly from GeoJSON or WKB/WKT, you *must* specifiy the expected coordinate dimensions, e.g. 
  `try Geometry<XY>(wkb: wkb)` or `decoder.decode(GeoJSON<XY>.self, from: data)`. `XY` coordinates will always work assuming the geometry is valid. Higher dimensions will
  throw an error if they don't have the appropriate coordinates available to decode.
* `WKBReader`/`WKTReader` can be used to read geometries of unknown coordinate types into an `AnyGeometry`.
* GeoJSON does not support M coordinates, so you cannot decode from JSON into that coordinate type.
* You can initialize a lower-dimensioned coordinate from a higher one assuming it has the relevant coordinates, e.g
  `let pointXY = Point<XY>(Point(x: 1, y: 2, z: 3))`. You cannot initialize a `XYM` type from a `XYZ` type or vice versa.
  
For geographic operations, specifically:
* For the most part, Z/M coordinates are treated as user data that do not impact the result of the topological operations and
  predicates which are XY planar by nature.
* To the extent that GEOS handles Z/M, there are 4 behaviors: preserve, drop, interpolate, set NaN. The behavior varies by
  function in a relatively intuitive way, but there are some inconsistencies (e.g. `simplify` drops M coordinates).
* It is common for GEOS to set Z and--especially--M coordinates to `nan` in the cases that it is creating new coordinates.
  Be aware that in Swift, `nan != nan`, so if you need to do equality checks on coordinates from an operation, it is safest
  to create an `XY` version of the geometry since X and Y coordinates will always be non-`nan`. Another option is to use a
  topological predicate--which don't check Z/M coordinates.
* It is also common to receive back `XY` geometry even when using higher-dimension inputs because the semantics of the
  operation imply only `XY` results (e.g. `minimumWidth` or `nearestPoints`).
* GEOSwift encodes the proper return dimensions in the type given by an operation, so other than being aware of the
  information above, you can trust the dimensions of the return type.

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
