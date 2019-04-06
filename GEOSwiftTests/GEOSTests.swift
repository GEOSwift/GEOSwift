//
//  GEOSwiftTests.swift
//
//  Created by Andrea Cremaschi on 21/05/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//
//  swiftlint:disable file_length

import Foundation
import XCTest
import GEOSwift

// swiftlint:disable:next type_body_length
class GEOSwiftTests: XCTestCase {

    var waypoint: Waypoint!
    var lineString: LineString!
    var linearRing: LinearRing!
    var polygon: GEOSwift.Polygon!
    var geometryCollection: GeometryCollection<Geometry>!
    var multiPoint: MultiPoint<Waypoint>!

    override func setUp() {
        super.setUp()
        waypoint = Waypoint(latitude: 9, longitude: 45)
        lineString = LineString(points: [Coordinate(x: 3, y: 4),
                                         Coordinate(x: 10, y: 50),
                                         Coordinate(x: 20, y: 25)])
        linearRing = LinearRing(points: [Coordinate(x: 35, y: 10),
                                         Coordinate(x: 45, y: 45),
                                         Coordinate(x: 15, y: 40),
                                         Coordinate(x: 10, y: 20),
                                         Coordinate(x: 35, y: 10)])
        polygon = Polygon(shell: linearRing,
                          holes: [LinearRing(points: [Coordinate(x: 20, y: 30),
                                                      Coordinate(x: 35, y: 35),
                                                      Coordinate(x: 30, y: 20),
                                                      Coordinate(x: 20, y: 30)])!])
        geometryCollection = GeometryCollection(geometries: [waypoint, lineString])
        multiPoint = MultiPoint(points: [waypoint])
    }

    override func tearDown() {
        multiPoint = nil
        geometryCollection = nil
        polygon = nil
        linearRing = nil
        lineString = nil
        waypoint = nil
        super.tearDown()
    }

    func testInitPointFromWKT() {
        guard let testWaypoint = Waypoint(WKT: "POINT(45 9)") else {
            XCTFail("WKT parse failed")
            return
        }
        XCTAssertEqual(testWaypoint, waypoint)
        XCTAssertEqual(testWaypoint.coordinate.x, 45)
        XCTAssertEqual(testWaypoint.coordinate.y, 9)
    }

    func testInitLinestringFromWKT() {
        guard let testLineString = LineString(WKT: "LINESTRING(3 4,10 50,20 25)") else {
            XCTFail("WKT parse failed")
            return
        }
        XCTAssertEqual(testLineString, lineString)
    }

    func testInitLinearRingFromWKT() {
        guard let testLinearRing = LinearRing(WKT: "LINEARRING(35 10,45 45,15 40,10 20,35 10)") else {
            XCTFail("WKT parse failed")
            return
        }
        XCTAssertEqual(testLinearRing, linearRing)
    }

    func testInitPolygonFromWKT() {
        let WKT = "POLYGON((35 10, 45 45, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))"
        guard let testPolygon = Polygon(WKT: WKT) else {
            XCTFail("WKT parse failed")
            return
        }
        XCTAssertEqual(testPolygon, polygon)
    }

    func testInitGeometryCollectionFromWKT() {
        let WKT = "GEOMETRYCOLLECTION(POINT(45 9),LINESTRING(3 4,10 50,20 25))"
        guard let testGeometryCollection = GeometryCollection(WKT: WKT) else {
            XCTFail("WKT parse failed")
            return
        }
        XCTAssertEqual(testGeometryCollection, geometryCollection)
    }

    func testInitMultiPointFromWKT() {
        guard let testMultiPoint = MultiPoint(WKT: "MULTIPOINT(45 9)") else {
            XCTFail("WKT parse failed")
            return
        }
        XCTAssertEqual(testMultiPoint, multiPoint)
    }

    func testCreatePointFromWKT() {
        guard let testWaypoint = Geometry.create("POINT(45 9)") as? Waypoint else {
            XCTFail("WKT parse failed (expected to receive a POINT)")
            return
        }
        XCTAssertEqual(testWaypoint, waypoint)
        XCTAssertEqual(testWaypoint.coordinate.x, 45)
        XCTAssertEqual(testWaypoint.coordinate.y, 9)
    }

    func testCreateLinestringFromWKT() {
        guard let testLineString = Geometry.create("LINESTRING(3 4,10 50,20 25)") as? LineString else {
            XCTFail("WKT parse failed (expected to receive a LINESTRING)")
            return
        }
        XCTAssertEqual(testLineString, lineString)
    }

    func testCreateLinearRingFromWKT() {
        guard let testLinearRing = Geometry.create("LINEARRING(35 10,45 45,15 40,10 20,35 10)") as? LinearRing else {
            XCTFail("WKT parse failed (expected to receive a LINEARRING)")
            return
        }
        XCTAssertEqual(testLinearRing, linearRing)
    }

    func testCreatePolygonFromWKT() {
        let WKT = "POLYGON((35 10, 45 45, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))"
        guard let testPolygon = Geometry.create(WKT) as? GEOSwift.Polygon else {
            XCTFail("WKT parse failed (expected to receive a POLYGON)")
            return
        }
        XCTAssertEqual(testPolygon, polygon)
    }

    func testCreateGeometryCollectionFromWKT() {
        let WKT = "GEOMETRYCOLLECTION(POINT(45 9),LINESTRING(3 4,10 50,20 25))"
        guard let testGeometryCollection = Geometry.create(WKT) as? GeometryCollection else {
            XCTFail("WKT parse failed (expected to receive a GEOMETRYCOLLECTION)")
            return
        }
        XCTAssertEqual(testGeometryCollection, geometryCollection)
    }

    func testCreateMultiPointFromWKT() {
        guard let testMultiPoint = Geometry.create("MULTIPOINT(45 9)") as? MultiPoint else {
            XCTFail("WKT parse failed (expected to receive a MULTIPOINT)")
            return
        }
        XCTAssertEqual(testMultiPoint, multiPoint)
    }

    func testCreateWKBFromPolygon() {
        guard let wkb = polygon.WKB else {
            XCTFail("Failed to generate WKB")
            return
        }
        XCTAssertFalse(wkb.isEmpty)
        guard let generatedPolygon = Geometry.create(wkb, size: wkb.count) else {
            XCTFail("Failed to create Polygon from generated WKB")
            return
        }
        XCTAssertEqual(polygon, generatedPolygon, "Polygon round-tripped via WKB is not equal")
    }

    func testInitPointFromData() {
        guard let wkbData = waypoint.WKB?.withUnsafeBufferPointer({ Data(buffer: $0) }) else {
            XCTFail("Failed to generate WKB")
            return
        }

        guard let testWaypoint = Waypoint(data: wkbData) else {
            XCTFail("WKB parse failed")
            return
        }

        XCTAssertEqual(testWaypoint, waypoint)
        XCTAssertEqual(testWaypoint.coordinate.x, 45)
        XCTAssertEqual(testWaypoint.coordinate.y, 9)
    }

    func testInitPolygonFromData() {
        guard let wkbData = polygon.WKB?.withUnsafeBufferPointer({ Data(buffer: $0) }) else {
            XCTFail("Failed to generate WKB")
            return
        }

        guard let testPolygon = Polygon(data: wkbData) else {
            XCTFail("WKB parse failed")
            return
        }

        XCTAssertEqual(testPolygon, polygon)
    }

    func testInitFromDataFailsWithInvalidGeometry() {
        let testWaypoint = Waypoint(data: Data(count: 8))
        XCTAssertNil(testWaypoint, "Eight nil bytes of data should not create a valid waypoint")
    }

    func testInitFromDataFailsWithTypeMismatch() {
        guard let wkbData = polygon.WKB?.withUnsafeBufferPointer({ Data(buffer: $0) }) else {
            XCTFail("Failed to generate WKB")
            return
        }

        let testWaypoint = Waypoint(data: wkbData)
        XCTAssertNil(testWaypoint, "Polygon WKB data should not create a valid waypoint")
    }

    // Test case for Issue #37
    // https://github.com/GEOSwift/GEOSwift/issues/37
    func testCreatePolygonFromLinearRing() {
        let lr = LinearRing(points: [Coordinate(x: -10, y: 10),
                                     Coordinate(x: 10, y: 10),
                                     Coordinate(x: 10, y: -10),
                                     Coordinate(x: -10, y: -10),
                                     Coordinate(x: -10, y: 10)])
        XCTAssertNotNil(lr, "Failed to create LinearRing")

        if let lr = lr {
            let polygon1 = Polygon(shell: lr, holes: nil)
            XCTAssertNotNil(polygon1, "Failed to create polygon from LinearRing")
        }
    }

    func testCreateEnvelopeFromCoordinates() {
        let env = Envelope(p1: Coordinate(x: -10, y: 10), p2: Coordinate(x: 10, y: -10))
        XCTAssertNotNil(env, "Failed to create Envelope")
        let geom = env!.envelope()
        XCTAssertEqual(env, geom)
    }

    func testCreateEnvelopeByExpanding() {
        let env = Envelope(p1: Coordinate(x: -10, y: 10), p2: Coordinate(x: 10, y: -10))
        XCTAssertNotNil(env, "Failed to create Envelope")
        let newEnv = Envelope.byExpanding(env!, toInclude: Waypoint(latitude: 11, longitude: 11)!)
        XCTAssertNotNil(env, "Failed to expand Envelope")
        XCTAssertEqual(newEnv!, Envelope(p1: Coordinate(x: -10, y: 11), p2: Coordinate(x: 11, y: -10))!)
    }

    func testCreateEnvelopeFromWaypoint() {
        let wp = Waypoint(latitude: -10, longitude: 10)!
        let env = wp.envelope()
        XCTAssertNotNil(env, "Failed to create Envelope")
        // Equatable on constructed Envelopes doesn’t seem to be working properly
        XCTAssertEqual(env!.topLeft, wp.coordinate)
        XCTAssertEqual(env!.bottomRight, wp.coordinate)
    }

    func testCreateEnvelopeFromMultipoint() {
        let mp = MultiPoint(points: [Waypoint(latitude: -10, longitude: 10)!, Waypoint(latitude: 10, longitude: -10)!])!
        let env = mp.envelope()
        XCTAssertNotNil(env, "Failed to create Envelope")
        XCTAssertEqual(env!, Envelope(p1: Coordinate(x: -10, y: 10), p2: Coordinate(x: 10, y: -10)))
    }

    func testCreateEnvelopeFromLineString() {
        let ls = LineString(points: [Coordinate(x: 10, y: -10), Coordinate(x: -10, y: 10)])!
        let env = ls.envelope()
        XCTAssertNotNil(env, "Failed to create Envelope")
        XCTAssertEqual(env!, Envelope(p1: Coordinate(x: -10, y: 10), p2: Coordinate(x: 10, y: -10)))
    }

    func testGeoJSON() {
        let bundle = Bundle(for: GEOSwiftTests.self)
        if let geojsons = bundle.urls(forResourcesWithExtension: "geojson", subdirectory: nil) {
            for geoJSONURL in geojsons {
                if case .some = try? Features.fromGeoJSON(geoJSONURL) {
                    XCTAssert(true, "GeoJSON correctly parsed")
                } else {
                    XCTAssert(false, "Can't extract geometry from GeoJSON: \(geoJSONURL.lastPathComponent)")
                }
            }
        }
    }

    func testNearestPoints() {
        let polygonWKT = "POLYGON((35 10, 45 45, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))"
        let point = Geometry.create("POINT(45 9)") as! Waypoint
        let polygon = Geometry.create(polygonWKT) as! GEOSwift.Polygon

        let arrNearestPoints = point.nearestPoints(polygon)

        XCTAssertNotNil(arrNearestPoints, "Failed to get nearestPoints array between the two geometries")
        XCTAssertEqual(arrNearestPoints.count, 2, "Number of expected points is 2")

        XCTAssertEqual(arrNearestPoints[0].x, point.nearestPoint(polygon).x)
        XCTAssertEqual(arrNearestPoints[0].y, point.nearestPoint(polygon).y)
    }

    func testArea() {
        let point = Geometry.create("POINT(45 9)") as! Waypoint
        XCTAssertEqual(0, point.area())

        let lr = LinearRing(points: [Coordinate(x: 0, y: 0),
                                     Coordinate(x: 1, y: 0),
                                     Coordinate(x: 1, y: 1),
                                     Coordinate(x: 0, y: 1),
                                     Coordinate(x: 0, y: 0)])!
        let polygon = Polygon(shell: lr, holes: nil)!
        XCTAssertEqual(1, polygon.area())
    }

    // swiftlint:disable:next function_body_length
    func testIsEqual() {
        let lhs = LineString(points: [Coordinate(x: 0, y: 0),
                                      Coordinate(x: 1, y: 0),
                                      Coordinate(x: 0, y: 1),
                                      Coordinate(x: 0, y: 0)])!

        // Same instance
        var rhs: Geometry = lhs

        XCTAssertTrue(lhs == rhs)
        XCTAssertTrue(rhs == lhs)
        XCTAssertTrue(lhs.isEqual(rhs))
        XCTAssertTrue(rhs.isEqual(lhs))

        // Distinct, but equivalent instance
        rhs = LineString(points: [Coordinate(x: 0, y: 0),
                                  Coordinate(x: 1, y: 0),
                                  Coordinate(x: 0, y: 1),
                                  Coordinate(x: 0, y: 0)])!

        XCTAssertTrue(lhs == rhs)
        XCTAssertTrue(rhs == lhs)
        XCTAssertTrue(lhs.isEqual(rhs))
        XCTAssertTrue(rhs.isEqual(lhs))

        // Non-equivalent instance
        rhs = LineString(points: [Coordinate(x: 0, y: 0),
                                  Coordinate(x: 2, y: 0),
                                  Coordinate(x: 0, y: 2),
                                  Coordinate(x: 0, y: 0)])!

        XCTAssertFalse(lhs == rhs)
        XCTAssertFalse(rhs == lhs)
        XCTAssertFalse(lhs.isEqual(rhs))
        XCTAssertFalse(rhs.isEqual(lhs))

        // Other type of object
        XCTAssertFalse(lhs.isEqual(NSObject()))

        // Equivalent subclass
        rhs = LinearRing(points: [Coordinate(x: 0, y: 0),
                                  Coordinate(x: 1, y: 0),
                                  Coordinate(x: 0, y: 1),
                                  Coordinate(x: 0, y: 0)])!

        XCTAssertTrue(lhs == rhs)
        XCTAssertTrue(rhs == lhs)
        XCTAssertTrue(lhs.isEqual(rhs))
        XCTAssertTrue(rhs.isEqual(lhs))

        // Non-equivalent subclass
        rhs = LinearRing(points: [Coordinate(x: 0, y: 0),
                                  Coordinate(x: 2, y: 0),
                                  Coordinate(x: 0, y: 2),
                                  Coordinate(x: 0, y: 0)])!

        XCTAssertFalse(lhs == rhs)
        XCTAssertFalse(rhs == lhs)
        XCTAssertFalse(lhs.isEqual(rhs))
        XCTAssertFalse(rhs.isEqual(lhs))
    }

    // Test case for Issue #85
    // https://github.com/GEOSwift/GEOSwift/issues/85
    func testStorageManagement() {
        func getLineStringFromCollection() -> LineString? {
            // Define the GeometryCollection in a separate scope, so that it is
            // deallocated before the returned LineString is used.
            let geometryCollection = GeometryCollection(geometries: [lineString])
            return geometryCollection?.geometries[0] as? LineString
        }
        guard let element = getLineStringFromCollection() else {
            XCTFail("Element creation failed")
            return
        }

        // Since the LineString depends on the underlying storage of the
        // GeometryCollection we need to ensure that the storage persists even
        // when the collection itself is destroyed. The following equality check
        // would crash when accessing the LineString storage.
        XCTAssertEqual(element, lineString)
    }

    func testCoordinatesCollection() {
        let collection = lineString.points

        XCTAssertEqual(collection.startIndex, 0)
        XCTAssertEqual(collection.endIndex, collection.count)
        XCTAssertEqual(collection.index(after: 0), 1)
        XCTAssertEqual(collection.index(after: 1), 2)
        XCTAssertEqual(collection.index(after: 2), 3)
    }
}
