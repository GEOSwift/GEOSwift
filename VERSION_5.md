# Version 5

## Introduction

GEOSwift was started in May 2015 by Andrea Cremaschi. At this time Swift 1.2 had
been out for just over a month. Over the years, the library and Swift both grew
and evolved, and new features in Swift like the [error handling
model][swift-error-handling] (Swift 2) and [Codable][swift-codable] (Swift 4)
started to make GEOSwift feel a bit less Swifty than it did originally. Even
early on, there was [a desire][classes-vs-structs] for GEOSwift to use structs
instead of classes, but the design did not allow it.

Additionally, other desires were difficult to address within the parameters of
the original design:

- Thread safety
- Increased test coverage (version 4 was at 71%)
- Support for general-purpose 2D geometry
- Useful errors when GeoJSON decoding fails

## A New Design

Version 5 brings a completely re-imagined, yet familiar, design to GEOSwift. The
changes can be grouped into 3 major areas:

1. Confine the use of GEOS
2. Move map-based features into a separate library
3. Adopt modern Swift features

### Confine the use of GEOS

Prior to version 5, each GEOSwift object was backed by a GEOS object. This meant
that GEOSwift objects needed to carefully manage C pointers and could not be
safely shared across threads. This was also [the reason][classes-vs-structs] why
it used classes instead of structs. Furthermore, the library used a single,
shared context for all interaction with GEOS. Even though it was using the
thread-safe GEOS API, that API only achieves thread-safety by allowing you to
create separate contexts per thread.

In version 5, GEOSwift represents all geometry types as Swift structs. GEOS is
still used, but only as an implementation detail for certain methods. In fact,
GEOS contexts never last beyond a single method call. This means that you can
pass GEOSwift values between threads and threads will never share GEOS contexts,
which, combined with the value semantics of struct, results in a thread-safe
API.

Additionally, this approach of confining the use of GEOS within the library,
opens up interesting future possibilities like splitting GEOS-dependent features
into a separate library for people who would prefer to avoid the GEOS dependency
or replacing GEOS-based implementations (which require careful error handling)
with Swift-native implementations.

### Move map-based features into a separate library

One of the appeals of GEOSwift 4 and earlier was its tight-knit integration with
MapKit and QuickLook. These features made it fun for experimentation in
playgrounds and quick to get something working in iOS projects.

Even so, there were other use cases that were made more difficult by the
inclusion of these features. Some developers were interested in using GEOSwift
for general-purpose geometry, but the QuickLook integration could crash if your
geometry was outside of the typical bounds of latitude and longitude. Others
wanted to use the library on Linux where UIKit and MapKit are not available.

To address these needs, version 5 moves the MapKit and UIKit-dependent features,
including QuickLook and the demo playground, into a separate library called
[GEOSwiftMapKit][mapkit]. This allows us to broaden the usefulness of the
library to include all kinds of general-purpose 2D geometry needs (not just
geography). This is possible because GEOS is already a general-purpose geometry
engine.

This change suggested that we ought to re-brand the library from "The Swift
Geographic Engine" to "The Swift Geometry Engine".

### Adopt modern Swift features

By adopting the Swift error handling model, version 5 reduces the use of
optionals, and can now bubble up errors from GEOS in a more programmer-friendly
way.

In adopting Codable, GEOSwift is now easy to combine with your app's own API
request and response objects that need to handle GeoJSON. You also get more
helpful error messages when decoding fails.

## Summary of API Changes

| Version 4 API                                                                              | Version 5 Equivalent                                                                            | Moved to GEOSwiftMapKit? | 
|--------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------|--------------------------| 
| CLLocationCoordinate2D.init(_ coord: Coordinate)                                           | CLLocationCoordinate2D.init(_ point: Point)                                                     | Yes                      | 
| Coordinate                                                                                 | Point                                                                                           |                          | 
| Coordinate.init(_ coord: CLLocationCoordinate2D)                                           | Point.init(_ coordinate: CLLocationCoordinate2D)                                                | Yes                      | 
| CoordinateDegrees                                                                          | Double                                                                                          |                          | 
| CoordinatesCollection                                                                      | [Point]                                                                                         |                          | 
| Envelope                                                                                   | Envelope                                                                                        |                          | 
| Envelope.bottomLeft: Coordinate                                                            | Envelope.minXMinY: Point                                                                        |                          | 
| Envelope.bottomRight: Coordinate                                                           | Envelope.maxXMinY: Point                                                                        |                          | 
| Envelope.byExpanding(_ base: Envelope, toInclude geom: Geometry) -> Envelope?              | GeometryCollection.init(geometries: [GeometryConvertible]).envelope() throws -> Envelope        |                          | 
| Envelope.byExpanding(_ base: Envelope, toIncludeCoordinate coord: Coordinate) -> Envelope? | GeometryCollection.init(geometries: [GeometryConvertible]).envelope() throws -> Envelope        |                          | 
| Envelope.init?(p1: Coordinate, p2: Coordinate)                                             | GeometryCollection.init(geometries: [GeometryConvertible]).envelope() throws -> Envelope        |                          | 
| Envelope.maxX: Double                                                                      | Envelope.maxX: Double                                                                           |                          | 
| Envelope.maxY: Double                                                                      | Envelope.maxY: Double                                                                           |                          | 
| Envelope.minX: Double                                                                      | Envelope.minX: Double                                                                           |                          | 
| Envelope.minY: Double                                                                      | Envelope.minY: Double                                                                           |                          | 
| Envelope.topLeft: Coordinate                                                               | Envelope.minXMaxY: Point                                                                        |                          | 
| Envelope.topRight: Coordinate                                                              | Envelope.maxXMaxY: Point                                                                        |                          | 
| Feature.geometries: [GEOSwift.Geometry]?                                                   | Feature.geometry: Geometry?                                                                     |                          | 
| Feature.id: Any?                                                                           | Feature.id: Feature.FeatureId?                                                                  |                          | 
| Feature.properties: NSDictionary?                                                          | Feature.properties: [String : JSON]?                                                            |                          | 
| Features                                                                                   | FeatureCollection                                                                               |                          | 
| Features.fromGeoJSON(_ data: Data) throws -> Features?                                     | FeatureCollection: Decodable                                                                    |                          | 
| Features.fromGeoJSON(_ string: String) throws -> Features?                                 | FeatureCollection: Decodable                                                                    |                          | 
| Features.fromGeoJSON(_ URL: URL) throws -> Features?                                       | FeatureCollection: Decodable                                                                    |                          | 
| Features.fromGeoJSONDictionary(_ dictionary: [String : AnyObject]) -> Features?            | FeatureCollection: Decodable                                                                    |                          | 
| GeometriesCollection                                                                       | [GeometryConvertible]                                                                           |                          | 
| Geometry.area() -> Double?                                                                 | GeometryConvertible.area() throws -> Double                                                     |                          | 
| Geometry.boundary() -> Geometry?                                                           | Boundable.boundary() throws -> Geometry                                                         |                          | 
| Geometry.buffer(width: Double) -> Geometry?                                                | GeometryConvertible.buffer(by width: Double) throws -> Geometry                                 |                          | 
| Geometry.centroid() -> Waypoint?                                                           | GeometryConvertible.centroid() throws -> Point                                                  |                          | 
| Geometry.contains(_ geometry: Geometry) -> Bool                                            | GeometryConvertible.contains(_ geometry: GeometryConvertible) throws -> Bool                    |                          | 
| Geometry.convexHull() -> Polygon?                                                          | GeometryConvertible.convexHull() throws -> Geometry                                             |                          | 
| Geometry.covers(_ geometry: Geometry) -> Bool                                              | GeometryConvertible.covers(_ geometry: GeometryConvertible) throws -> Bool                      |                          | 
| Geometry.create(_ WKB: UnsafePointer<UInt8>, size: Int) -> Geometry?                       | WKBInitializable.init(wkb: Data) throws                                                         |                          | 
| Geometry.create(_ WKT: String) -> Geometry?                                                | WKTInitializable.init(wkt: String) throws                                                       |                          | 
| Geometry.crosses(_ geometry: Geometry) -> Bool                                             | GeometryConvertible.crosses(_ geometry: GeometryConvertible) throws -> Bool                     |                          | 
| Geometry.difference(_ geometry: Geometry) -> Geometry?                                     | GeometryConvertible.difference(with geometry: GeometryConvertible) throws -> Geometry           |                          | 
| Geometry.disjoint(_ geometry: Geometry) -> Bool                                            | GeometryConvertible.isDisjoint(with geometry: GeometryConvertible) throws -> Bool               |                          | 
| Geometry.distance(geometry: Geometry) -> Double                                            | GeometryConvertible.distance(to geometry: GeometryConvertible) throws -> Double                 |                          | 
| Geometry.envelope() -> Envelope?                                                           | GeometryConvertible.envelope() throws -> Envelope                                               |                          | 
| Geometry.equals(_ geometry: Geometry) -> Bool                                              | GeometryCollection.isTopologicallyEquivalent(to geometry: GeometryConvertible) throws -> Bool   |                          | 
| Geometry.geometryTypeId() -> Int32                                                         | Removed                                                                                         |                          | 
| Geometry.init?(data: Data)                                                                 | WKBInitializable.init(wkb: Data) throws                                                         |                          | 
| Geometry.init?(WKB: [UInt8])                                                               | WKBInitializable.init(wkb: Data) throws                                                         |                          | 
| Geometry.init?(WKT: String)                                                                | WKTInitializable.init(wkt: String) throws                                                       |                          | 
| Geometry.intersection(_ geometry: Geometry) -> Geometry?                                   | GeometryConvertible.intersection(with geometry: GeometryConvertible) throws -> Geometry         |                          | 
| Geometry.intersects(_ geometry: Geometry) -> Bool                                          | GeometryConvertible.intersects(_ geometry: GeometryConvertible) throws -> Bool                  |                          | 
| Geometry.mapShape() -> MKShape?                                                            | MKPointAnnotation.init(point: Point)<br />MKPlacemark.init(point: Point)<br />MKPolyline.init(lineString: LineString)<br />MKPolygon.init(linearRing: Polygon.LinearRing)<br />MKPolygon.init(polygon: Polygon)<br />GeometryMapShape.init(geometry: GeometryConvertible) throws | Yes                                                                                             |                          | 
| Geometry.nearestPoint(_ geometry: Geometry) -> Coordinate                                  | GeometryConvertible.nearestPoints(with geometry: GeometryConvertible)[0]                        |                          | 
| Geometry.nearestPoints(_ geometry: Geometry) -> [Coordinate]                               | GeometryConvertible.nearestPoints(with geometry: GeometryConvertible) throws -> [Point]         |                          | 
| Geometry.overlaps(_ geometry: Geometry) -> Bool                                            | GeometryConvertible.overlaps(_ geometry: GeometryConvertible) throws -> Bool                    |                          | 
| Geometry.pointOnSurface() -> Waypoint?                                                     | GeometryConvertible.pointOnSurface() throws -> Point                                            |                          | 
| Geometry.relate(_ geometry: Geometry, pattern: String) -> Bool                             | GeometryConvertible.relate(_ geometry: GeometryConvertible, mask: String) throws -> Bool        |                          | 
| Geometry.relationship(_ geometry: Geometry) -> String                                      | GeometryConvertible.relate(_ geometry: GeometryConvertible) throws -> String                    |                          | 
| Geometry.touches(_ geometry: Geometry) -> Bool                                             | GeometryConvertible.touches(_ geometry: GeometryConvertible) throws -> Bool                     |                          | 
| Geometry.unaryUnion() -> Geometry?                                                         | GeometryConvertible.unaryUnion() throws -> Geometry                                             |                          | 
| Geometry.union(_ geometry: Geometry) -> Geometry?                                          | GeometryConvertible.union(with geometry: GeometryConvertible) throws -> Geometry                |                          | 
| Geometry.within(_ geometry: Geometry) -> Bool                                              | GeometryConvertible.isWithin(_ geometry: GeometryConvertible) throws -> Bool                    |                          | 
| Geometry.WKB: [UInt8]?                                                                     | WKBConvertible.wkb() throws -> Data                                                             |                          | 
| Geometry.WKT: String?                                                                      | WKTConvertible.wkt() throws -> String                                                           |                          | 
| GeometryCollection<T>.init?(geometries: [T]) where T : Geometry                            | GeometryCollection.init(geometries: [GeometryConvertible])                                      |                          | 
| HumboldtVersionNumber                                                                      | GEOSwiftVersionNumber                                                                           |                          | 
| LineString.distanceFromOriginToProjectionOfPoint(point: Waypoint) -> Double                | LineStringConvertible.distanceFromStart(toProjectionOf point: Point) throws -> Double           |                          | 
| LineString.init?(points: [Coordinate])                                                     | LineString.init(points: [Point]) throws                                                         |                          | 
| LineString.interpolatePoint(distance: Double) -> Waypoint?                                 | LineStringConvertible.interpolatedPoint(withDistance distance: Double) throws -> Point          |                          | 
| LineString.interpolatePoint(fraction: Double) -> Waypoint?                                 | LineStringConvertible.interpolatedPoint(withFraction fraction: Double) throws -> Point          |                          | 
| LineString.middlePoint() -> Waypoint?                                                      | LineStringConvertible.interpolatedPoint(withFraction: 0.5) throws -> Point                      |                          | 
| LineString.normalizedDistanceFromOriginToProjectionOfPoint(point: Waypoint) -> Double      | LineStringConvertible.normalizedDistanceFromStart(toProjectionOf point: Point) throws -> Double |                          | 
| MKShapesCollection                                                                         | GeometryMapShape                                                                                | Yes                      | 
| Polygon.exteriorRing                                                                       | Polygon.exterior                                                                                |                          | 
| Polygon.init?(shell: LinearRing, holes: [LinearRing]?)                                     | Polygon.init(exterior: Polygon.LinearRing, holes: [Polygon.LinearRing] = [])                    |                          | 
| Polygon.interiorRings                                                                      | Polygon.holes                                                                                   |                          | 
| Waypoint                                                                                   | Point                                                                                           |                          | 
| Waypoint.coordinate: Coordinate                                                            | Point                                                                                           |                          | 
| Waypoint.init?(latitude: CoordinateDegrees, longitude: CoordinateDegrees)                  | Point.init(x: Double, y: Double)                                                                |                          | 
| Waypoint.init?(latitude: CoordinateDegrees, longitude: CoordinateDegrees)                  | Point.init(longitude: Double, latitude: Double)                                                 | Yes                      | 


## What about Objective-C?

The new GEOSwift is all struct based, so to add ObjC support, we'd either need
to switch back to using classes or create a set of wrapper classes. Neither of
these options make much sense right now though: Switching to classes would lose
many of the advantages of the new design, and it's not clear how we could make
the MapKit and QuickLook add-ons work with both libraries. Initially it seemed
like ObjC support was a must-have to match the features of the previous version,
but after reviewing the existing ObjC interface, it turns out that there was
never much ObjC support to begin with. If the community still wants this badly
enough, we should consider spinning up a sister project (GEOObjC?) so that we
can focus on making GEOSwift a truly first-rate experience for Swift projects.

[swift-error-handling]: https://docs.swift.org/swift-book/LanguageGuide/ErrorHandling.html
[swift-codable]: https://developer.apple.com/documentation/swift/codable
[classes-vs-structs]: https://github.com/GEOSwift/GEOSwift/commit/e420bd49dcae5c21d2a5759a2f88b67c08d56994#diff-2dd84631947429a85fb0c3044e551525R26
[mapkit]: https://github.com/GEOSwift/GEOSwiftMapKit
