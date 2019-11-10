## 6.0.0

* [#187](https://github.com/GEOSwift/GEOSwift/pull/187)
    * Add support for Swift PM on iOS and tvOS (Fixes
      [#166](https://github.com/GEOSwift/GEOSwift/issues/166))
    * Update Swift PM support on macOS and Linux to build geos from source
      instead of using system packages. This provides increased consistency with
      CocoaPods and Carthage and enables us to support iOS and tvOS as well.

## 5.2.0

* [#186](https://github.com/GEOSwift/GEOSwift/pull/186)
    * Add isEmpty, isRing, isClosed, and isSimple (Fixes
      [#172](https://github.com/GEOSwift/GEOSwift/issues/172))
    * Update Feature.init to take GeometryConvertible (Fixes
      [#180](https://github.com/GEOSwift/GEOSwift/issues/180))
    * Use `~>` to specify geos version requirement (Fixes
      [#183](https://github.com/GEOSwift/GEOSwift/issues/183))

## 5.1.0

* [#171](https://github.com/GEOSwift/GEOSwift/pull/171) Add conveniences for
  working with JSON, Feature, and Feature.FeatureId

## 5.0.0

* [#167](https://github.com/GEOSwift/GEOSwift/pull/167) See
  [VERSION_5.md](VERSION_5.md)

## 4.1.1

* [#163](https://github.com/GEOSwift/GEOSwift/pull/163) Fix building on projects
  with spaces in path
* [#164](https://github.com/GEOSwift/GEOSwift/pull/164) Updated geos dependency
  to 4.0.2 (CocoaPods & Carthage)

## 4.1.0

* [#153](https://github.com/GEOSwift/GEOSwift/pull/153) Add Carthage support
* [#154](https://github.com/GEOSwift/GEOSwift/pull/154) Add public init for
  Feature

## 4.0.0

* [#144](https://github.com/GEOSwift/GEOSwift/pull/144) Upgrade to CocoaPods
  1.6.1, Xcode 10.2, and Swift 5

## 3.1.2

* [#147](https://github.com/GEOSwift/GEOSwift/pull/147) Fixed leak resulting
  from an early return not destroying an object

## 3.1.1

* [#138](https://github.com/GEOSwift/GEOSwift/pull/138) Exclude Bridge.swift
  from podspec

## 3.1.0

* [#131](https://github.com/GEOSwift/GEOSwift/pull/131) Add support for Swift
  Package Manager and Geometry.init?(data:)
* [#135](https://github.com/GEOSwift/GEOSwift/pull/135) Fix
  MKShapesCollection.boundingMapRect

## 3.0.3

* Updated to GEOS 3.7.1

## 3.0.2

* [#125](https://github.com/GEOSwift/GEOSwift/pull/125) Fix mapShape for common
  GeometryCollection types

## 3.0.1

* [#120](https://github.com/GEOSwift/GEOSwift/pull/120) Added @objc prefix to
  expose methods and variables to Objective-C code

## 3.0.0

* Upgraded to GEOS 3.7.0
* Bug fixes
* Support for Xcode 10, Swift 4.2
