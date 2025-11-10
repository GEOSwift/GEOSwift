![GEOSwift](/README-images/GEOSwift.png)

[![Swift Package Manager Compatible](https://img.shields.io/badge/SwiftPM-compatible-4BC51D.svg?style=flat)](https://swift.org/package-manager/)
[![Build Status](https://github.com/GEOSwift/GEOSwift/actions/workflows/main.yml/badge.svg)](https://github.com/GEOSwift/GEOSwift/actions/workflows/main.yml)

Easily handle a geometric object model (points, linestrings, polygons etc.) and
related topological operations (intersections, overlapping etc.). A type-safe,
MIT-licensed Swift interface to the OSGeo's GEOS library routines.

> **For *MapKit* integration visit: https://github.com/GEOSwift/GEOSwiftMapKit**<br />
> **For *MapboxGL* integration visit: https://github.com/GEOSwift/GEOSwiftMapboxGL**<br />

## Quick Start

```swift
import GEOSwift

// Create a point
let point = Point(x: 4.5, y: 4.5)

// Create a polygon
let polygon = try Polygon<XY>(wkt: "POLYGON((0 0, 0 5, 5 5, 5 0, 0 0))")

// Check if the point is within the polygon
let isInside = try point.within(polygon) // true
```

## Table of Contents

- [Quick Start](#quick-start)
- [Features](#features)
- [Minimum Requirements](#minimum-requirements)
- [Installation](#installation)
- [Usage](#usage)
  - [Coordinate Dimensions](#coordinate-dimensions-coordinatetype)
  - [Geometry Creation](#geometry-creation)
  - [Topological Operations](#topological-operations)
  - [Predicates](#predicates)
  - [Playground](#playground)
- [Migration Guide](#migrating-from-11xx)
- [Contributing](#contributing)
- [Maintainer](#maintainer)
- [License](#license)

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

        .package(url: "https://github.com/GEOSwift/GEOSwift.git", from: "12.0.0")

2. Update the target dependencies in your `Package.swift` to include

        "GEOSwift"

In certain cases, you may also need to explicitly include
[geos](https://github.com/GEOSwift/geos.git) as a dependency. See
[issue #195](https://github.com/GEOSwift/GEOSwift/issues/195) for details.

## Usage

### Geometry Creation

#### From WKB/WKT

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

#### From GeoJSON (via `Codable`)

When decoding from GeoJSON, you must specify the expected `CoordinateType` of the geometry.
The two compatible `CoordinateType`s are `XY` and `XYZ`. GeoJSON does not support M coordinates. Decoding as
`Geometry<XY>` will drop any Z values present. The behavior of decoding as `Geometry<XYZ>` depends on
the `CodingUserInfo.geoJSONSetMissingZNan` value in the decoder's `userInfo`:
* **`false`**: (default) Decoding will throw a `GEOSwiftError.invalidCoordinates` if no Z value exists.
* **`true`**: Any missing Z values will be treated as `Double.nan`.

This setting is useful if you are dealing with geometry with unknown dimensionality and you want to preserve Z
where possible, or if you have geometry with mixed dimensionality.

> [!NOTE]
> Take special care working with `Double.nan` in Swift. It can often produce unexpected results such as 
> `Double.nan != Double.nan` which may interfere with equality checks. Converting the geometry to `XY` using
> the conversion initializers (e.g. `let geometryXY = Geometry<XY>(geometry)`) is a safe way to mitigate this
> when Z is not needed. The underlying GEOS operations generally handle Z == NaN cases fine since Z is not
> considered in topological operations.

```swift
// When decoding GeoJSON, you must explicitly declare the expected geometry coordinate type (e.g. GeoJSON<XY>)
var decoder = JSONDecoder()
let json = #"{"coordinates":[1,2],"type":"Point"}"#
let data = json.data(using: .utf8)!

let geometryXY = try decoder.decode(Geometry<XY>.self, from: data) // This works
let geometryXYZ = try decoder.decode(Geometry<XYZ>.self, from: data) // This throws an error because no Z value

decoder.userInfo[.geoJSONSetMissingZNan] = true
let geometryXYNan = try decoder.decode(Geometry<XYZ>.self, from: data) // This gives a NaN value for Z

let jsonWithZ = #"{"coordinates":[1,2,3],"type":"Point"}"#
let dataWithZ = jsonWithZ.data(using: .utf8)!

let geometryDropZ = try decoder.decode(Geometry<XY>.self, from: dataWithZ) // Drops the Z coordinate
```

#### Initializing Geometry types directly

There are several different ways to initialize geometry types directly.

```swift
// Using coordinate types directly
let lineString1 = LineString(coordinates: [
    XYZ(1, 2, 3), 
    XYZ(4, 5, 6)
])

// Using implied coordinate types via tuples (not available for XYM)
let lineString2 = LineString(coordinates: [
    (1, 2, 3), 
    (4, 5, 6)
])

// Using convenience initializers
let point1 = Point(x: 1, y: 2, z: 3)
let point2 = Point(x: 4, y: 5, z: 6)
let lineString3 = LineString(point: [point1, point2])

// Using copy constructors to downcast coordinate types
let lineStringXYZM = LineString(coordinates: [
    (1, 2, 3, 0),
    (4, 5, 6, 0)
])
let lineString4 = LineString<XYZ>(lineStringXYZM)

lineString1 == lineString2 // true
lineString1 == lineString3 // true
lineString1 == lineString4 // true
```

### Coordinate Dimensions (`CoordinateType`)

GEOSwift, like GEOS, supports geometry with 2 (`XY`), 3 (`XYZ`/`XYM`), and 4 (`XYZM`) coordinates. There are some important
things to know about using various coordinate types, mixing dimensionalities, and the impact on encoding/decoding
and geometric operations.

* The `XY` coordinate type is generally the safest and most intuitive. If you don't *need* Z/M, prefer keeping things 2D.
* When decoding geometry directly from GeoJSON or WKB/WKT, you have three options:
  * Explicitly type the expected `CoordinateType` e.g. `try Geometry<XYZ>(wkb: wkb)` or `decoder.decode(GeoJSON<XYZ>.self, from: data)`. This will error if there are fewer ordinates than needed present in the data.
  * Use `readAny` on `[WKB|WKT]Reader` or `CodingUserInfo.geoJSONSetMissingZNan` for GeoJSON to decode unknown `CoordinateType`s.
  * Decode as `XY` geometry which will always work for valid geometries by dropping Z/M ordinates.
* GeoJSON does not support M coordinates, so you cannot decode from JSON into `XYM`/`XYZM` geometries.
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

### Topological Operations

Let's say we have two geometries:

![Example geometries](/README-images/geometries.png)

GEOSwift lets you perform a set of operations on these two geometries:

![Topological operations](/README-images/topological-operations.png)

#### Code Examples

```swift
let polygon1 = try Polygon<XY>(wkt: "POLYGON((0 0, 0 5, 5 5, 5 0, 0 0))")
let polygon2 = try Polygon<XY>(wkt: "POLYGON((2 2, 2 7, 7 7, 7 2, 2 2))")

// Intersection - the area where both polygons overlap
let intersection = try polygon1.intersection(with: polygon2)

// Union - the combined area of both polygons
let union = try polygon1.union(with: polygon2)

// Difference - the area in polygon1 that's not in polygon2
let difference = try polygon1.difference(with: polygon2)

// Symmetric difference - areas in either polygon but not both
let symDifference = try polygon1.symmetricDifference(with: polygon2)

// Buffer - creates a geometry representing all points within a distance
let buffered = try polygon1.buffer(by: 1.0)

// Convex hull - smallest convex polygon containing the geometry
let hull = try polygon1.convexHull()
```

### Predicates

GEOSwift provides spatial predicates to test relationships between geometries:

* **equals**: returns true if this geometric object is "spatially equal" to another geometry.
* **disjoint**: returns true if this geometric object is "spatially disjoint" from another geometry.
* **intersects**: returns true if this geometric object "spatially intersects" another geometry.
* **touches**: returns true if this geometric object "spatially touches" another geometry.
* **crosses**: returns true if this geometric object "spatially crosses" another geometry.
* **within**: returns true if this geometric object is "spatially within" another geometry.
* **contains**: returns true if this geometric object "spatially contains" another geometry.
* **overlaps**: returns true if this geometric object "spatially overlaps" another geometry.
* **relate**: returns true if this geometric object is spatially related to another geometry by testing for intersections between the interior, boundary and exterior of the two geometric objects as specified by the values in the intersectionPatternMatrix.

#### Code Examples

```swift
let point = Point(x: 4.5, y: 4.5)
let polygon = try Polygon<XY>(wkt: "POLYGON((0 0, 0 5, 5 5, 5 0, 0 0))")
let line = try LineString<XY>(wkt: "LINESTRING(0 0, 10 10)")

// Check if point is within polygon
let isWithin = try point.within(polygon) // true

// Check if geometries intersect
let intersects = try line.intersects(polygon) // true

// Check if polygon contains point
let contains = try polygon.contains(point) // true

// Check if geometries are disjoint (don't intersect)
let point2 = Point(x: 10, y: 10)
let disjoint = try point2.disjoint(polygon) // true
```

### Playground

Explore more, interactively, in the playground, which is available in the
[GEOSwiftMapKit](https://github.com/GEOSwift/GEOSwiftMapKit) project. It can be
found inside `GEOSwiftMapKit` workspace. Open the workspace in Xcode, build the
`GEOSwiftMapKit` framework and open the playground file.

![Playground](/README-images/playground.png)

### Migrating from 11.x.x

GEOSwift 12.0.0 introduced a few changes that you may need to incorporate to upgrade. Though in
some cases, convenience methods were retained to ease migration.
* `Geometry` and geometric types are now generic over `CoordinateType`. Specifying `XY` as the
  `CoordinateType` will give you largely the same behavior as 11.x.x. You can also use the copy
  constructors to down-convert the dimensions of a type (`let point = Point<XY>(pointXZYM)`).
* The new base type for forming geometries is a `CoordinateType` (e.g. `XY`) rather than `Point`s.
  Initializing with points is still supported but is now deprecated.
* The `AnyGeometry` object is used in a few cases to wrap geometries where the `CoordinateType` isn't
  known at compile-time. You can unwrap this at run-time.

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

* Scott Hoyt ([@scottrhoyt](https://github.com/scottrhoyt))

## Past Maintainers

* Andrew Hershberger ([@macdrevx](https://github.com/macdrevx))
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
