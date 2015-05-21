//
//  Humboldt.swift
//
//  Created by Andrea Cremaschi on 26/04/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

import Foundation
import geos

var GEOS_HANDLE: COpaquePointer = {
    return initGEOSWrapper_r();
}()

enum GeometryType {
    case Point
    case LineString
    case LinearRing
    case Polygon
    case MultiPoint
    case MultiLineString
    case MultiPolygon
    case GeometryCollection
}

public class Geometry {

    let geometry: COpaquePointer!
    public let points: PointsCollection!

    private init(GEOSGeom: COpaquePointer) {
        geometry = GEOSGeom
        points = PointsCollection(geometry: GEOSGeom)
    }
    
    public convenience init?(WKT: String) {
        let WKTReader = GEOSWKTReader_create_r(GEOS_HANDLE);
        let GEOSGeom = GEOSWKTReader_read_r(GEOS_HANDLE, WKTReader, (WKT as NSString).UTF8String);
        GEOSWKTReader_destroy_r(GEOS_HANDLE, WKTReader);
        self.init(GEOSGeom: GEOSGeom)
        if GEOSGeom == nil {
            return nil
        }
    }

    public convenience init?(WKB: UnsafePointer<UInt8>, size: Int) {
        let WKBReader = GEOSWKBReader_create_r(GEOS_HANDLE);
        let GEOSGeom = GEOSWKBReader_read_r(GEOS_HANDLE, WKBReader, WKB, size);
        GEOSWKBReader_destroy_r(GEOS_HANDLE, WKBReader);
        self.init(GEOSGeom: GEOSGeom)
        if GEOSGeom == nil {
            return nil
        }
    }
}

public struct PointsCollection {
    let geometry: COpaquePointer
    init(geometry: COpaquePointer) {
        self.geometry = geometry
    }
    public subscript(index: Int) -> Point {
        var x: Double = 0
        var y: Double = 0
        let sequence = GEOSGeom_getCoordSeq_r(GEOS_HANDLE, self.geometry)
        GEOSCoordSeq_getX_r(GEOS_HANDLE, sequence, 0, &x);
        GEOSCoordSeq_getY_r(GEOS_HANDLE, sequence, 0, &y);

        return Point(x: x, y: y)
    }
    
    public func count() -> UInt32 {
        let sequence = GEOSGeom_getCoordSeq_r(GEOS_HANDLE, self.geometry)
        var count: UInt32 = 0
        GEOSCoordSeq_getSize_r(GEOS_HANDLE, sequence, &count);
        return count
    }
}

public struct Point {
    public let x: Double
    public let y: Double
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}