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

}
