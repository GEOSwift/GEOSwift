## 11.2.0

* [#264](https://github.com/GEOSwift/GEOSwift/pull/264) Add initial support for prepared geometry

## 11.1.0

* [#290](https://github.com/GEOSwift/GEOSwift/pull/290) Add `LineStringConvertible.substring(fromFraction:toFraction:)`

## 11.0.0

* [#284](https://github.com/GEOSwift/GEOSwift/pull/284) Update GEOS, CI, and Apple Platform Versions
* [#285](https://github.com/GEOSwift/GEOSwift/pull/285) Fix crash in polygonize()

## 10.3.0

* [#281](https://github.com/GEOSwift/GEOSwift/pull/281) Add `GeometryConvertible.lineMergeDirected()` and `GeometryConvertible.lineMerge()`
* [#282](https://github.com/GEOSwift/GEOSwift/pull/282) Add `GeometryConvertible.offsetCurve(width:quadsegs:joinStyle:mitreLimit:)`

## 10.2.0

* [#271](https://github.com/GEOSwift/GEOSwift/pull/271) Expose `GeometryConvertible.bufferWithStyle(width:quadsegs:endCapStyle:joinStyle:mitreLimit:)`
* [#274](https://github.com/GEOSwift/GEOSwift/pull/274) Treat lint warnings as errors in CI

## 10.1.0

* [#259](https://github.com/GEOSwift/GEOSwift/pull/259) Expose
  `GeometryConvertible.makeValid(method:)`.
* Fix warnings when building tests with Xcode 14.3.

## 10.0.0

* [#250](https://github.com/GEOSwift/GEOSwift/pull/250) Add
  `GeometryConvertible.snap(to:)`.
* [#255](https://github.com/GEOSwift/GEOSwift/pull/255) Add
  `GeometryConvertible.hausdorffDistance(to:)` and
  `GeometryConvertible.hausdorffDistance(to:densifyFraction:)`.
* [#256](https://github.com/GEOSwift/GEOSwift/issues/256) Add
  `GeometryConvertible.concaveHull(withRatio:allowHoles:)`.
* [#247](https://github.com/GEOSwift/GEOSwift/issues/247) Add
  `Sendable` conformances and more `Hashable` conformances.
* Update to GEOSwift/geos 8.1.0 (geos 3.11.2)

## 9.0.0

* [#224](https://github.com/GEOSwift/GEOSwift/pull/224)
  `GeometryConvertible.buffer(by:)` can now be used with negative widths.
* [#232](https://github.com/GEOSwift/GEOSwift/pull/232) Dependency and tooling
  support updates:
    * Updates to GEOSwift/geos 7.0.0 (libgeos/geos 3.10.1)
    * Increases swift-tools-version to 5.3 (corresponds to Xcode 12)
    * Drops support for Carthage
    * Reorganizes sources to match Swift Package Manager conventions
* [#235](https://github.com/GEOSwift/GEOSwift/pull/235) Added
  `GeometryConvertible.symmetricDifference(with:)`
* [#236](https://github.com/GEOSwift/GEOSwift/pull/236) Updated
  `LineStringConvertible` methods to use implementations from geos:
    * `normalizedDistanceFromStart(toProjectionOf:)`: The geos implementation
      returns 0 for 0-length lines, whereas the old GEOSwift implementation
      threw `GEOSwiftError.lengthIsZero`, which has now been removed.
    * `interpolatedPoint(withFraction:)`

## 8.1.0

* [#218](https://github.com/GEOSwift/GEOSwift/pull/218) Added
  `GeometryConvertible.simplify(withTolerance:)`

## 8.0.2

* [#216](https://github.com/GEOSwift/GEOSwift/issues/216) Changed the value of
  the quadsegs param in buffer(by:) to match the geos default.

## 8.0.1

* Add platform specifiers to Package.swift

## 8.0.0

* Updated for Xcode 12
    * Drops support for iOS 8
    * Switches to SPM as primary development environment
    * Updates GEOSwift.xcodeproj to use geos.xcframework instead of the
      old-style fat frameworks due to a change in Xcode 12.3. This breaks
      (hopefully only temporarily) compatibility with Carthage unless you use
      the as-of-yet-unreleased Carthage version which adds the
      `--use-xcframeworks` flag. Carthage support will be reevaluated as its
      situation evolves.
* Increases min geos to 6.0.0 (which equates to 3.9.0 in the upstream geos)

## 7.2.0

* [#211](https://github.com/GEOSwift/GEOSwift/pull/211)
    * Adds isValid, isValidReason, and isValidDetail

## 7.1.0

* [#202](https://github.com/GEOSwift/GEOSwift/pull/202)
    * Add makeValid

## 7.0.0

* [#201](https://github.com/GEOSwift/GEOSwift/pull/201)
    * Update to geos 3.8.1 (GEOSwift/geos 5.0.0)
        * Return values from intersection and difference are now optional
        * Buffer now throws `GEOSwiftError.negativeBufferWidth` if width is
          negative
    * Add minimumBoundingCircle (Fixes
      [#157](https://github.com/GEOSwift/GEOSwift/issues/157))

## 6.2.0

* [#200](https://github.com/GEOSwift/GEOSwift/pull/200)
    * Add polygonize (Fixes
      [#139](https://github.com/GEOSwift/GEOSwift/issues/139))

## 6.1.0

* [#197](https://github.com/GEOSwift/GEOSwift/pull/197)
    * Expose options to configure WKT writing (Fixes
      [#196](https://github.com/GEOSwift/GEOSwift/issues/196))

## 6.0.0

* [#187](https://github.com/GEOSwift/GEOSwift/pull/187)
    * Add support for Swift PM on iOS and tvOS (Fixes
      [#166](https://github.com/GEOSwift/GEOSwift/issues/166))
    * Update Swift PM support on macOS and Linux to build geos from source
      instead of using system packages. This provides increased consistency
      with CocoaPods and Carthage and enables us to support iOS and tvOS as
      well.

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

* [#163](https://github.com/GEOSwift/GEOSwift/pull/163) Fix building on
  projects with spaces in path
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
