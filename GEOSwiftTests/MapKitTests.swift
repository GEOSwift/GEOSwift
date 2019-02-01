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
        if let polygon = Geometry.create(WKT) as? GEOSwift.Polygon,
            polygon.mapShape() as? MKPolygon != nil {
            result = true
        }
        XCTAssert(result, "MKPolygon test failed")
    }

    func verifyMapShape(withGeometryCollection geometryCollection: Geometry?, line: UInt = #line) {
        guard let geometryCollection = geometryCollection else {
            XCTFail("geometryCollection was nil", line: line)
            return
        }
        if !(geometryCollection.mapShape() is MKShapesCollection) {
            XCTFail("\(geometryCollection) did not produce a MKShapesCollection", line: line)
        }
    }

    func testCreateMKShapesCollectionFromGeometryCollections() {
        verifyMapShape(withGeometryCollection: GeometryCollection<Geometry>(geometries: []))
        verifyMapShape(withGeometryCollection: GeometryCollection<Waypoint>(geometries: []))
        verifyMapShape(withGeometryCollection: GeometryCollection<GEOSwift.Polygon>(geometries: []))
        verifyMapShape(withGeometryCollection: GeometryCollection<Envelope>(geometries: []))
        verifyMapShape(withGeometryCollection: GeometryCollection<LineString>(geometries: []))
        verifyMapShape(withGeometryCollection: GeometryCollection<LinearRing>(geometries: []))
        verifyMapShape(withGeometryCollection: MultiPoint<Waypoint>(points: []))
        verifyMapShape(withGeometryCollection: MultiPolygon<GEOSwift.Polygon>(polygons: []))
        verifyMapShape(withGeometryCollection: MultiPolygon<Envelope>(polygons: []))
        verifyMapShape(withGeometryCollection: MultiLineString<LineString>(linestrings: []))
        verifyMapShape(withGeometryCollection: MultiLineString<LinearRing>(linestrings: []))
    }

    // Test case for Issue #134
    // https://github.com/GEOSwift/GEOSwift/issues/134
    func testMKShapesCollectionHasBoundingMapRectWithPositiveWidthAndHeight() {
        guard let linestring = LineString(points: [Coordinate(x: -1, y: 1), Coordinate(x: 1, y: -1)]),
            let geometryCollection = GeometryCollection(geometries: [linestring]) else {
                XCTFail("unable to create geometries")
                return
        }
        let mkShapesCollection = MKShapesCollection(geometryCollection: geometryCollection)

        let boundingMapRect = mkShapesCollection.boundingMapRect

        XCTAssertGreaterThan(boundingMapRect.height, 0)
        XCTAssertGreaterThan(boundingMapRect.width, 0)
    }

    func testCLLocationCoordinate2DToAndFromCoordinate() {
        let coordinate = Coordinate(x: 2, y: 1)
        let clLocationCoordinate2D = CLLocationCoordinate2D(latitude: 1, longitude: 2)

        XCTAssertEqual(CLLocationCoordinate2D(coordinate), clLocationCoordinate2D)
        XCTAssertEqual(Coordinate(clLocationCoordinate2D), coordinate)
    }
}
