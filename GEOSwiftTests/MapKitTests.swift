//
//  MapKitTests.swift
//  GEOSwift
//
//  Created by Andrea Cremaschi on 10/06/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

import Foundation
import XCTest
import GEOSwift
import MapKit

final class MapKitTests: XCTestCase {

    func testCreateMKPointAnnotationFromPoint() {
        var result = false
        if let point = Geometry.create("POINT(45 9)") as? Waypoint,
            point.mapShape() as? MKPointAnnotation != nil {
            result = true
        }
        XCTAssert(result, "MKPoint test failed")
    }

    func testCreateMKPolylineFromLineString() {
        var result = false
        let WKT = "LINESTRING(3 4,10 50,20 25)"
        if let linestring = Geometry.create(WKT) as? LineString,
            linestring.mapShape() as? MKPolyline != nil {
            result = true
        }
        XCTAssert(result, "MKPolyline test failed")
    }

    func testCreateMKPolygonFromPolygon() {
        var result = false
        let WKT = "POLYGON((35 10, 45 45, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))"
        if let polygon = Geometry.create(WKT) as? Polygon,
            polygon.mapShape() as? MKPolygon != nil {
            result = true
        }
        XCTAssert(result, "MKPolygon test failed")
    }

    func testCreateMKShapesCollectionFromGeometryCollection() {
        var result = false
        let WKT = "GEOMETRYCOLLECTION(POINT(4 6),LINESTRING(4 6,7 10))"
        if let geometryCollection = Geometry.create(WKT) as? GeometryCollection,
            geometryCollection.mapShape() as? MKShapesCollection != nil {
            result = true
        }
        XCTAssert(result, "MKShapesCollection test failed")
    }

    func testCLLocationCoordinate2DToAndFromCoordinate() {
        let coordinate = Coordinate(x: 2, y: 1)
        let clLocationCoordinate2D = CLLocationCoordinate2D(latitude: 1, longitude: 2)

        XCTAssertEqual(CLLocationCoordinate2D(coordinate), clLocationCoordinate2D)
        XCTAssertEqual(Coordinate(clLocationCoordinate2D), coordinate)
    }
}
