# GEOS.swift
*The Open Source Geographic Engine, in Swift.*

[![Build Status](https://travis-ci.org/andreacremaschi/GEOS.swift.svg)](https://travis-ci.org/andreacremaschi/GEOS.swift)
[![Cocoapods Compatible](https://img.shields.io/cocoapods/v/GEOS.swift.svg)](https://img.shields.io/cocoapods/v/GEOS.swift.svg)

Handle all kind of geographic objects (points, linestrings, polygons etc.) and all related topographic operations (intersections, overlapping etc.). GEOS.swift is basically a MIT-licensed Swift interface to the OSGeo's GEOS library routines*, plus some convenience features for iOS developers.

## Features

* A pure-Swift, type-safe, optional-aware programming interface
* Automatically-typed geometry deserialization from WKT and WKB representations
* *MapKit* integration
* *Quicklook* integration
* A lightweight *GEOJSON* parser
* Well-documented
* Extensively tested

## Requirements

* iOS 8.0+ / Mac OS X 10.10+
* Xcode 6.3
* Swift 1.2+
* CocoaPods 0.37+

## Usage

### Geometry creation

```swift
// From Well Known Text (WKT) representation
let point = Waypoint(WKT: "POINT(10 45)")
let polygon = Geometry.create("POLYGON((35 10, 45 45.5, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))")
// From Well Known Binary (WKB) representation
// TODO:
// From a GeoJSON file:
if let geoJSONURL = NSBundle.mainBundle().URLForResource("italy", withExtension: "geojson"),
    let geometries = Geometry.fromGeoJSON(geoJSONURL),
    let italy = geometries[0] as? MultiPolygon
{
    italy
}
```

### MapKit integration

```swift
let shape1 = point!.mapShape()
let shape2 = polygon!.mapShape()
let annotations = [shape1, shape2]
```

### Topological operations

` Buffer, Boundary, Centroid, ConvexHull, Envelope, PointOnSurface, Intersection, Difference, Union`

### Predicates:
`Intersects, Touches, Disjoint, Crosses, Within, Contains, Overlaps, Equals, Covers`

## Installation

> **Embedded frameworks require a minimum deployment target of iOS 8 or OS X Mavericks.**
> GEOS is a configure/install project licensed under LGPL 2.1: it is difficult to build for iOS and its compatibility with static linking is at least controversial. Use of GEOS.swift without CocoaPods and with a project targeting iOS 7, even if possible, is advised against.

### CocoaPods

CocoaPods is a dependency manager for Cocoa projects. To install GEOS.swift with CocoaPods:

* Make sure CocoaPods is installed (SQLite.swift requires version 0.37 or greater).

* Update your `Podfile` to include the following:

```
use_frameworks!
pod 'GEOS.swift'
```

* Run `pod install`.

## Creator

Andrea Cremaschi ([@andreacremaschi](https://twitter.com/andreacremaschi))

## License

* GEOS.swift was released by Andrea Cremaschi ([@andreacremaschi](https://twitter.com/andreacremaschi)) under a MIT license. See LICENSE for more information.
* [GEOS](http://trac.osgeo.org/geos/) stands for Geometry Engine - Open Source, and is a C++ library, ported from the [Java Topology Suite](http://sourceforge.net/projects/jts-topo-suite/). GEOS implements the OpenGIS [Simple Features for SQL](http://www.opengeospatial.org/standards/sfs) spatial predicate functions and spatial operators. GEOS, now an OSGeo project, was initially developed and maintained by [Refractions Research](http://www.refractions.net/) of Victoria, Canada.