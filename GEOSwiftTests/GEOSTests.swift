//
//  GEOSwiftTests.swift
//
//  Created by Andrea Cremaschi on 21/05/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

import Foundation
import XCTest
import GEOSwift

class GEOSwiftTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCreatePointFromWKT() {
        var result = false
        if let point = Geometry.create("POINT(45 9)") as? Waypoint,
            let point2 = Waypoint(WKT: "POINT(45 9)") {
            result = point.coordinate.x == 45 && point.coordinate.y == 9 && point == point2
        }
        XCTAssert(result, "WKT parse failed (expected to receive a POINT)")
    }

    func testCreateLinestringFromWKT() {
        var result = false
        let WKT = "LINESTRING(3 4,10 50,20 25)"
        if let linestring = Geometry.create(WKT) as? LineString,
            let linestring2 = LineString(WKT: WKT) {
            result = linestring.points.count == 3 && linestring.points[0].x == 3 && linestring.points[0].y == 4 && linestring == linestring2
        }
        XCTAssert(result, "WKT parse failed (expected to receive a LINESTRING)")
    }
    
    func testCreateLinearRingFromWKT() {
        var result = false
        let WKT = "LINEARRING(3 4,10 50,20 25,3 4)"
        if let linearring = Geometry.create(WKT) as? LinearRing,
            let linearring2 = LinearRing(WKT: WKT) {
            result = linearring.points.count == 4 && linearring.points[0].x == 3 && linearring.points[0].y == 4 && linearring == linearring2
        }
        XCTAssert(result, "WKT parse failed (expected to receive a LINEARRING)")
    }

    func testCreatePolygonFromWKT() {
        var result = false
        let WKT = "POLYGON((35 10, 45 45, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))"
        if let polygon = Geometry.create(WKT) as? Polygon,
            let polygon2 = Polygon(WKT: WKT){
            let exteriorRing = polygon.exteriorRing
            result = polygon.interiorRings.count == 1 && exteriorRing.points.count == 5 && exteriorRing.points[0].x == 35 && exteriorRing.points[0].y == 10 && polygon == polygon2
        }
        XCTAssert(result, "WKT parse failed (expected to receive a POLYGON)")
    }
    
    // Test case for Issue #37
    // https://github.com/andreacremaschi/GEOSwift/issues/37
    func testCreatePolygonFromLinearRing() {
        let lr = LinearRing(points: [Coordinate(x:-10, y:10), Coordinate(x:10, y:10), Coordinate(x:10, y:-10), Coordinate(x:-10, y:-10), Coordinate(x:-10, y:10)])
        XCTAssertNotNil(lr, "Failed to create LinearRing")
        
        if let lr = lr
        {
            let polygon1 = Polygon(shell: lr, holes: nil)
            XCTAssertNotNil(polygon1, "Failed to create polygon from LinearRing")
        }
    }

    func testCreateEnvelopeFromCoordinates() {
        let env = Envelope(p1: Coordinate(x:-10, y:10), p2: Coordinate(x:10, y:-10))
        XCTAssertNotNil(env, "Failed to create Envelope")
        let geom = env!.envelope()
        XCTAssertEqual(env, geom)
    }
    
    func testCreateEnvelopeByExpanding() {
        let env = Envelope(p1: Coordinate(x:-10, y:10), p2: Coordinate(x:10, y:-10))
        XCTAssertNotNil(env, "Failed to create Envelope")
        let newEnv = Envelope.byExpanding(env!, toInclude: Waypoint(latitude: 11, longitude: 11)!)
        XCTAssertNotNil(env, "Failed to expand Envelope")
        XCTAssertEqual(newEnv!,  Envelope(p1: Coordinate(x:-10, y:11), p2: Coordinate(x:11, y:-10))!)
    }
    
    func testCreateGeometriesCollectionFromWKT() {
        var result = false
        let WKT = "GEOMETRYCOLLECTION(POINT(4 6),LINESTRING(4 6,7 10))"
        if let geometryCollection = Geometry.create(WKT) as? GeometryCollection,
            let geometryCollection2 = GeometryCollection(WKT: WKT) {
            if geometryCollection.geometries.count == 2 && geometryCollection2 == geometryCollection,
                let _ = geometryCollection.geometries[0] as? Waypoint,
                let _ = geometryCollection.geometries[1] as? LineString {
                result = true
            }
        }
        XCTAssert(result, "WKT parse failed (expected to receive a GEOMETRYCOLLECTION containing a POINT and a LINESTRING)")
    }

    func testCreateMultiPointFromWKT() {
        var result = false
        let WKT = "MULTIPOINT(-2 0,-1 -1,0 0,1 -1,2 0,0 2,-2 0)"
        if let multiPoint = Geometry.create(WKT) as? MultiPoint,
            let multiPoint2 = MultiPoint(WKT: WKT) {
            if multiPoint.geometries.count == 7 && multiPoint == multiPoint2 {
                result = true
            }
        }
        XCTAssert(result, "WKT parse failed (expected to receive a MULTIPOINT)")
    }

    func testGeoJSON() {
        let bundle = Bundle(for: GEOSwiftTests.self)
        if let geojsons = bundle.urls(forResourcesWithExtension: "geojson", subdirectory: nil) {
            for geoJSONURL in geojsons {
                if let features = try! Features.fromGeoJSON(geoJSONURL)  {
//                    geometries[0].debugQuickLookObject()
                    XCTAssert(true, "GeoJSON correctly parsed")
                    print("\(geoJSONURL.lastPathComponent): \(features)")
                } else {
                    XCTAssert(false, "Can't extract geometry from GeoJSON: \(geoJSONURL.lastPathComponent)")
                }
            }
        }
    }
    
    func testNearestPoints() {
        let point = Geometry.create("POINT(45 9)") as! Waypoint
        let polygon = Geometry.create("POLYGON((35 10, 45 45, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))") as! Polygon
        
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
}
