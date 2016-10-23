//
//  Geometries.swift
//  GEOSwift
//
//  Created by Andrea Cremaschi on 10/06/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

import Foundation

/**
A `Waypoint` is a 0-dimensional geometry and represents a single location in coordinate space. A `Waypoint` has a x- coordinate value and a y-coordinate value.
The boundary of a `Waypoint` is the empty set.
*/
open class Waypoint : Geometry {
    open let coordinate: Coordinate
    
    open override class func geometryTypeId() -> Int32 {
        return 0 // GEOS_POINT
    }

    public required init(GEOSGeom: OpaquePointer, destroyOnDeinit: Bool) {
        let isValid = GEOSGeomTypeId_r(GEOS_HANDLE, GEOSGeom) == Waypoint.geometryTypeId() // GEOS_POINT
        
        if (!isValid) {
            coordinate = Coordinate(x: 0, y: 0)
        } else {
            let points = CoordinatesCollection(geometry: GEOSGeom)
            if points.count>0 {
                self.coordinate = points[0]
            } else {
                coordinate = Coordinate(x: 0, y: 0)
            }
        }
        super.init(GEOSGeom: GEOSGeom, destroyOnDeinit: destroyOnDeinit)
    }

    public convenience init?(WKT: String) {
        guard let GEOSGeom = GEOSGeomFromWKT(GEOS_HANDLE, WKT: WKT),
            Geometry.classForGEOSGeom(GEOSGeom) === Waypoint.self else {
            return nil
        }
        self.init(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
    }
    
    public convenience init?(latitude: CoordinateDegrees, longitude: CoordinateDegrees) {
        let seq = GEOSCoordSeq_create_r(GEOS_HANDLE, 1,2)
        GEOSCoordSeq_setX_r(GEOS_HANDLE, seq, 0, longitude)
        GEOSCoordSeq_setY_r(GEOS_HANDLE, seq, 0, latitude)
        guard let GEOSGeom = GEOSGeom_createPoint_r(GEOS_HANDLE, seq) else {
            return nil
        }
        self.init(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
    }
}

/**
A `Polygon` is a planar surface, defined by 1 exterior boundary and 0 or more interior boundaries. Each interior boundary defines a hole in the `Polygon`.

The assertions for polygons (the rules that define valid polygons) are:

1. Polygons are topologically closed.
2. The boundary of a Polygon consists of a set of LinearRings that make up its exterior and interior boundaries.
3. No two rings in the boundary cross, the rings in the boundary of a Polygon may intersect at a Point but only as a tangent.
4. A Polygon may not have cut lines, spikes or punctures.
5. The Interior of every Polygon is a connected point set.
6. The Exterior of a Polygon with 1 or more holes is not connected. Each hole defines a connected component of the Exterior.
*/
open class Polygon : Geometry {
    
    open override class func geometryTypeId() -> Int32 {
        return 3 // GEOS_POLYGON
    }
    
    public required init(GEOSGeom: OpaquePointer, destroyOnDeinit: Bool) {
        super.init(GEOSGeom: GEOSGeom, destroyOnDeinit: destroyOnDeinit)
    }
    
    /// - returns: the exterior ring of this Polygon.
    fileprivate(set) open lazy var exteriorRing: LinearRing = {
        let exteriorRing = GEOSGetExteriorRing_r(GEOS_HANDLE, self.geometry)!
        let linestring = Geometry.create(exteriorRing, destroyOnDeinit: false) as! LinearRing
        return linestring
        }()
    
    /// - returns: an array with the interior rings of this Polygon.
    fileprivate(set) open lazy var interiorRings: [LinearRing] = {
        var interiorRings = [LinearRing]()
        let numInteriorRings = GEOSGetNumInteriorRings_r(GEOS_HANDLE, self.geometry)
        if numInteriorRings>0 {
            for index in 0...numInteriorRings-1 {
                if let interiorRingGEOSGeom = GEOSGetInteriorRingN_r(GEOS_HANDLE, self.geometry, index),
                    let ring = Geometry.create(interiorRingGEOSGeom, destroyOnDeinit: false) as? LinearRing {
                    interiorRings.append(ring)
                }
            }
        }
        return interiorRings
        }()
    
    public convenience init?(WKT: String) {
        guard let GEOSGeom = GEOSGeomFromWKT(GEOS_HANDLE, WKT: WKT),
            Geometry.classForGEOSGeom(GEOSGeom) === Polygon.self else {
                return nil
        }
        self.init(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
    }
    
    public convenience init?(shell: LinearRing, holes: Array<LinearRing>?) {
        // clone shell
        let shellGEOSGeom = GEOSGeom_clone_r(GEOS_HANDLE, shell.geometry)

        // clone holes
        var geometriesPointer: UnsafeMutablePointer<OpaquePointer?>? = nil
        if let holes = holes, holes.count > 0 {
            geometriesPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: holes.count)
            for (i, geom) in holes.enumerated() {
                let GEOSGeom = GEOSGeom_clone_r(GEOS_HANDLE, geom.geometry)
                geometriesPointer?[i] = GEOSGeom
            }
            defer {
                geometriesPointer?.deallocate(capacity: holes.count)
            }
        }
        guard let geometry = GEOSGeom_createPolygon_r(GEOS_HANDLE, shellGEOSGeom, geometriesPointer, UInt32(holes?.count ?? 0)) else {
            return nil
        }
        self.init(GEOSGeom: geometry, destroyOnDeinit: true)
    }
}

/**
    A `LineString` is a Curve with linear interpolation between points. Each consecutive pair of points defines a line segment.
*/
open class LineString : Geometry {
    
    open override class func geometryTypeId() -> Int32 {
        return 1 // GEOS_LINESTRING
    }
    
    fileprivate(set) open lazy var points: CoordinatesCollection = {
        return CoordinatesCollection(geometry: self.geometry)
        }()
    
    public convenience init?(WKT: String) {
        guard let GEOSGeom = GEOSGeomFromWKT(GEOS_HANDLE, WKT: WKT),
            Geometry.classForGEOSGeom(GEOSGeom) == LineString.self else {
                return nil
        }
        self.init(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
    }
    
    public convenience init?(points: [Coordinate]) {
        let seq = GEOSCoordSeq_create_r(GEOS_HANDLE, UInt32(points.count), 2)
        for (i,coord) in points.enumerated() {
            GEOSCoordSeq_setX_r(GEOS_HANDLE, seq, UInt32(i), coord.x)
            GEOSCoordSeq_setY_r(GEOS_HANDLE, seq, UInt32(i), coord.y)
        }
        guard let GEOSGeom = GEOSGeom_createLineString_r(GEOS_HANDLE, seq) else {
            return nil
        }
        self.init(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
    }
}

/**
    A LinearRing is a LineString that is both closed and simple.
*/
open class LinearRing : LineString {
    
}

/**
A GeometryCollection is a geometry that is a collection of 1 or more geometries.
*/
open class GeometryCollection<T: Geometry> : Geometry {
    
    open override class func geometryTypeId() -> Int32 {
        return 7 // GEOS_GEOMETRYCOLLECTION
    }
    
    fileprivate(set) open lazy var geometries: GeometriesCollection<T> = {
        return GeometriesCollection<T>(geometry: self.geometry)
        }()
    public required init(GEOSGeom: OpaquePointer, destroyOnDeinit: Bool) {
        super.init(GEOSGeom: GEOSGeom, destroyOnDeinit: destroyOnDeinit)
    }
    fileprivate convenience init(GEOSGeom: OpaquePointer) {
        self.init(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
    }
    
    public convenience init?(WKT: String) {
        guard let GEOSGeom = GEOSGeomFromWKT(GEOS_HANDLE, WKT: WKT),
            Geometry.classForGEOSGeom(GEOSGeom) === GeometryCollection.self else {
                return nil
        }
        self.init(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
    }

/**
    - returns: An Array of geometries in this GeometryCollection.
*/
    public convenience init?(geometries: Array<Geometry>) {
        let geometriesPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: geometries.count)
        defer { geometriesPointer.deallocate(capacity: geometries.count) }
        for (i, geom) in geometries.enumerated() {
            let GEOSGeom = GEOSGeom_clone_r(GEOS_HANDLE, geom.geometry)
            geometriesPointer[i] = GEOSGeom
        }
        
        guard let geometry = GEOSGeom_createCollection_r(GEOS_HANDLE, type(of: self).geometryTypeId(), geometriesPointer, UInt32(geometries.count)) else {
            return nil
        }
        self.init(GEOSGeom: geometry, destroyOnDeinit: true)
    }
}

/**
A `MultiLineString` is a `GeometryCollection` of `LineStrings`.
*/
open class MultiLineString<T: LineString> : GeometryCollection<LineString> {
    
    open override class func geometryTypeId() -> Int32 {
        return 5 // GEOS_MULTILINESTRING
    }
    
    public required init(GEOSGeom: OpaquePointer, destroyOnDeinit: Bool) {
        super.init(GEOSGeom: GEOSGeom, destroyOnDeinit: destroyOnDeinit)
    }
    fileprivate convenience init(GEOSGeom: OpaquePointer) {
        self.init(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
    }
    public convenience init?(WKT: String) {
        guard let GEOSGeom = GEOSGeomFromWKT(GEOS_HANDLE, WKT: WKT),
            Geometry.classForGEOSGeom(GEOSGeom) === MultiLineString.self else {
                return nil
        }
        self.init(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
    }
    public convenience init?(linestrings: Array<LineString>) {
        let geometriesPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: linestrings.count)
        defer { geometriesPointer.deallocate(capacity: linestrings.count) }
        for (i, geom) in linestrings.enumerated() {
            let GEOSGeom = GEOSGeom_clone_r(GEOS_HANDLE, geom.geometry)
            geometriesPointer[i] = GEOSGeom
        }
        
        guard let geometry = GEOSGeom_createCollection_r(GEOS_HANDLE, type(of: self).geometryTypeId(), geometriesPointer, UInt32(linestrings.count)) else {
            return nil
        }
        self.init(GEOSGeom: geometry, destroyOnDeinit: true)
    }
}

/**
A `MultiPoint` is a `GeometryCollection` of `Point`s.
*/
open class MultiPoint<T: Waypoint> : GeometryCollection<Waypoint> {
    open override class func geometryTypeId() -> Int32 {
        return 4 // GEOS_MULTIPOINT
    }
    public required init(GEOSGeom: OpaquePointer, destroyOnDeinit: Bool) {
        super.init(GEOSGeom: GEOSGeom, destroyOnDeinit: destroyOnDeinit)
    }
    fileprivate convenience init(GEOSGeom: OpaquePointer) {
        self.init(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
    }
    public convenience init?(WKT: String) {
        guard let GEOSGeom = GEOSGeomFromWKT(GEOS_HANDLE, WKT: WKT),
            Geometry.classForGEOSGeom(GEOSGeom) === MultiPoint.self else {
                return nil
        }
        self.init(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
    }
    public convenience init?(points: Array<Waypoint>) {
        let coordsPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: points.count)
        defer { coordsPointer.deallocate(capacity: points.count) }
        for (i, geom) in points.enumerated() {
            let GEOSGeom = GEOSGeom_clone_r(GEOS_HANDLE, geom.geometry)
            coordsPointer[i] = GEOSGeom
        }
        
        guard let geometry = GEOSGeom_createCollection_r(GEOS_HANDLE, type(of: self).geometryTypeId(), coordsPointer, UInt32(points.count)) else {
            return nil
        }
        self.init(GEOSGeom: geometry, destroyOnDeinit: true)
    }
    
}

/**
A `MultiPolygon` is a `GeometryCollection` of `Polygon`s.
*/
open class MultiPolygon<T: Polygon> : GeometryCollection<Polygon> {
    open override class func geometryTypeId() -> Int32 {
        return 6 // GEOS_MULTIPOLYGON
    }
    public required init(GEOSGeom: OpaquePointer, destroyOnDeinit: Bool) {
        super.init(GEOSGeom: GEOSGeom, destroyOnDeinit: destroyOnDeinit)
    }
    fileprivate convenience init(GEOSGeom: OpaquePointer) {
        self.init(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
    }
    public convenience init?(WKT: String) {
        guard let GEOSGeom = GEOSGeomFromWKT(GEOS_HANDLE, WKT: WKT),
            Geometry.classForGEOSGeom(GEOSGeom) === MultiPolygon.self else {
                return nil
        }
        self.init(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
    }
    public convenience init?(polygons: Array<Polygon>) {
        let coordsPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: polygons.count)
        defer { coordsPointer.deallocate(capacity: polygons.count) }
        for (i, geom) in polygons.enumerated() {
            let GEOSGeom = GEOSGeom_clone_r(GEOS_HANDLE, geom.geometry)
            coordsPointer[i] = GEOSGeom
        }
        
        guard let geometry = GEOSGeom_createCollection_r(GEOS_HANDLE, type(of: self).geometryTypeId(), coordsPointer, UInt32(polygons.count)) else {
            return nil
        }
        self.init(GEOSGeom: geometry, destroyOnDeinit: true)
    }
}
