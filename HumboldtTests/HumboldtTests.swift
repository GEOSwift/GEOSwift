//
//  HumboldtTests.swift
//  geosswifttest2
//
//  Created by Andrea Cremaschi on 21/05/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

import UIKit
import XCTest
import HumboldtDemo

class HumboldtTests: XCTestCase {

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
        if let point = Geometry.create("POINT(45 9)") as? Point {
            result = point.coordinate.x == 45 && point.coordinate.y == 9
        }
        XCTAssert(result, "WKT parse failed (expected to receive a POINT)")
    }

    func testCreateLinestringFromWKT() {
        var result = false
        if let linestring = Geometry.create("LINESTRING(3 4,10 50,20 25)") as? LineString {
            result = linestring.points.count() == 3 && linestring.points[0].x == 3 && linestring.points[0].y == 4
        }
        XCTAssert(result, "WKT parse failed (expected to receive a LINESTRING)")
    }

    func testCreatePolygonFromWKT() {
        var result = false
        if let polygon = Geometry.create("POLYGON((35 10, 45 45, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))") as? Polygon {
            let exteriorRing = polygon.exteriorRing
            result = polygon.interiorRings.count == 1 && exteriorRing.points.count() == 5 && exteriorRing.points[0].x == 35 && exteriorRing.points[0].y == 10
        }
        XCTAssert(result, "WKT parse failed (expected to receive a POLYGON)")
    }

    func testCreateGeometriesCollectionFromWKT() {
        var result = false
        if let geometryCollection = Geometry.create("GEOMETRYCOLLECTION(POINT(4 6),LINESTRING(4 6,7 10))") as? GeometryCollection {
            if geometryCollection.geometries.count == 2,
                let polygon = geometryCollection.geometries[0] as? Point,
                let linestring = geometryCollection.geometries[1] as? LineString {
                    result = true
            }
        }
        XCTAssert(result, "WKT parse failed (expected to receive a GEOMETRYCOLLECTION containing a POINT and a LINESTRING)")
    }

    func testCreateMultiPointFromWKT() {
        var result = false
        if let multiPoint = Geometry.create("MULTIPOINT(-2 0,-1 -1,0 0,1 -1,2 0,0 2,-2 0)") as? GeometryCollection<Point> {
            if multiPoint.geometries.count == 7 {
                result = true
            }
        }
        XCTAssert(result, "WKT parse failed (expected to receive a MULTIPOINT)")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
