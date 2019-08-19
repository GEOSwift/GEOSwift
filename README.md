![GEOSwift](/README-images/GEOSwift.png)

[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/GEOSwift.svg)](https://cocoapods.org/pods/GEOSwift)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Supported Platforms](https://img.shields.io/cocoapods/p/GEOSwift.svg?style=flat)](https://github.com/GEOSwift/GEOSwift)
[![Build Status](https://img.shields.io/travis/GEOSwift/GEOSwift/master)](https://travis-ci.org/GEOSwift/GEOSwift)
[![Code Coverage](https://img.shields.io/codecov/c/github/GEOSwift/GEOSwift/master)](https://codecov.io/gh/GEOSwift/GEOSwift)

Easily handle a geometric object model (points, linestrings, polygons etc.) and related topological operations (intersections, overlapping etc.). A type-safe, MIT-licensed Swift interface to the OSGeo's GEOS library routines.

> **For *MapKit* integration visit: https://github.com/GEOSwift/GEOSwiftMapKit**<br />
> **For *MapboxGL* integration visit: https://github.com/GEOSwift/GEOSwiftMapboxGL** (volunteer needed to maintain GEOSwiftMapboxGL)<br />

## Migrating to Version 5

Version 5 constitutes a ground-up rewrite of GEOSwift. For full details and help migrating from version 4, see [VERSION_5.md](VERSION_5.md).

## Features

* A pure-Swift, type-safe, optional-aware programming interface
* WKT and WKB reading & writing
* Robust support for *GeoJSON* via Codable
* Thread-safe
* Swift-native error handling
* Extensively tested

## Requirements

* iOS 8.0+, tvOS 9.0+, macOS 10.9+
* Xcode 10.2
* Swift 5.0

## Installation

### CocoaPods

1. Install autotools: `$ brew install autoconf automake libtool`
2. Update your `Podfile` to include:

```
use_frameworks!
pod 'GEOSwift'
```

3. Run `$ pod install`

> GEOS is a configure/install project licensed under LGPL 2.1: it is difficult to build for iOS and its compatibility with static linking is at least controversial. Use of GEOSwift without dynamic-framework-based CocoaPods and with a project targeting iOS 7, even if possible, is advised against.

### Carthage

1. Install autotools: `$ brew install autoconf automake libtool`
2. Add the following to your Cartfile:

```
github "GEOSwift/GEOSwift" ~> 5.1.0
```

3. Finish updating your project by following the [typical Carthage
workflow](https://github.com/Carthage/Carthage#quick-start).

### Swift Package Manager

GEOSwift supports SPM on macOS & Linux. [Instructions](SPM.md)

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
    case let .feature(feature) = geoJson,
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

* _equals_: returns true if this geometric object is “spatially equal” to another geometry.
* _disjoint_: returns true if this geometric object is “spatially disjoint” from another geometry.
* _intersects_: returns true if this geometric object “spatially intersects” another geometry.
* _touches_: returns true if this geometric object “spatially touches” another geometry.
* _crosses_: returns true if this geometric object “spatially crosses’ another geometry.
* _within_: returns true if this geometric object is “spatially within” another geometry.
* _contains_: returns true if this geometric object “spatially contains” another geometry.
* _overlaps_: returns true if this geometric object “spatially overlaps” another geometry.
* _relate_: returns true if this geometric object is spatially related to another geometry by testing for intersections between the interior, boundary and exterior of the two geometric objects as specified by the values in the intersectionPatternMatrix.

### Playground

Explore more, interactively, in the playground, which is available in the [GEOSwiftMapKit](https://github.com/GEOSwift/GEOSwiftMapKit)
project. It can be found inside `GEOSwiftMapKit` workspace. Open the workspace in Xcode, build the `GEOSwiftMapKit` framework and open the playground file.

![Playground](/README-images/playground.png)

## Contributing

To make a contribution:

* Fork the repo
* Start from the `develop` branch and create a branch with a name that describes your contribution
* Run `$ carthage update`
* Sign in to travis-ci.org (if you've never signed in before, CI won't run to verify your pull request)
* Push your branch and create a pull request to develop
* One of the maintainers will review your code and may request changes
* If your pull request is accepted, one of the maintainers should update the changelog before merging it

## Maintainer

* Andrew Hershberger ([@macdrevx](https://github.com/macdrevx))

## Past Maintainers

* Virgilio Favero Neto ([@vfn](https://github.com/vfn))
* Andrea Cremaschi ([@andreacremaschi](https://twitter.com/andreacremaschi)) (original author)

## License

* GEOSwift was released by Andrea Cremaschi ([@andreacremaschi](https://twitter.com/andreacremaschi)) under a MIT license. See LICENSE for more information.
* [GEOS](http://trac.osgeo.org/geos/) stands for Geometry Engine - Open Source, and is a C++ library, ported from the [Java Topology Suite](http://sourceforge.net/projects/jts-topo-suite/). GEOS implements the OpenGIS [Simple Features for SQL](http://www.opengeospatial.org/standards/sfs) spatial predicate functions and spatial operators. GEOS, now an OSGeo project, was initially developed and maintained by [Refractions Research](http://www.refractions.net/) of Victoria, Canada.
