//
//  GEOS.swift
//
//  Created by Andrea Cremaschi on 26/04/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

import Foundation
import geos

var GEOS_HANDLE: COpaquePointer = {
    return initGEOSWrapper_r();
}()

/// A base abstract geometry class
@objc public class Geometry : Equatable {

    let geometry: COpaquePointer
    internal let destroyOnDeinit: Bool
    
    required public init(GEOSGeom: COpaquePointer, destroyOnDeinit: Bool) {
        self.geometry = GEOSGeom
        self.destroyOnDeinit = destroyOnDeinit
    }

    deinit {
//        println("Destroying \(self)")
        if (self.destroyOnDeinit) {
            GEOSGeom_destroy_r(GEOS_HANDLE, geometry);
        }
    }
    
    internal convenience init(GEOSGeom: COpaquePointer) {
        self.init(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
    }

    internal class func create(GEOSGeom: COpaquePointer, destroyOnDeinit: Bool) -> Geometry? {
        if GEOSGeom == nil {
            return nil
        }
        if let subclass = Geometry.classForGEOSGeom(GEOSGeom) {
            return subclass(GEOSGeom: GEOSGeom, destroyOnDeinit: destroyOnDeinit)
        }
        return nil
    }
    
    public class func geometryTypeId() -> Int32 {
        return -1 // Abstract
    }
    
    internal class func classForGEOSGeom(GEOSGeom: COpaquePointer) -> Geometry.Type? {
        if (GEOSGeom == nil) {
            return nil
        }
        let geometryTypeId = GEOSGeomTypeId_r(GEOS_HANDLE, GEOSGeom)
        var subclass: Geometry.Type

        switch geometryTypeId {
        case 0: // GEOS_POINT
            subclass = Waypoint.self
            
        case 1: // GEOS_LINESTRING:
            subclass = LineString.self
            
        case 2: // GEOS_LINEARRING:
            subclass = LinearRing.self
            
        case 3: // GEOS_POLYGON:
            subclass = Polygon.self
            
        case 4: // GEOS_MULTIPOINT:
            subclass = MultiPoint.self
            
        case 5: // GEOS_MULTILINESTRING:
            subclass = MultiLineString.self
            
        case 6: // GEOS_MULTIPOLYGON:
            subclass = MultiPolygon.self
            
        case 7: // GEOS_GEOMETRYCOLLECTION:
            subclass = GeometryCollection<Geometry>.self
            
        default:
            return nil
        }
        return subclass
    }
    
    private class func create(GEOSGeom: COpaquePointer) -> Geometry? {
        return self.create(GEOSGeom, destroyOnDeinit: true)
    }

    /**
    Create a Geometry subclass from its Well Known Text representation.
    
    :param: WKT The geometry representation in Well Known Text format (i.e. `POINT(10 45)`).
    
    :returns: The proper Geometry subclass as parsed from the string (i.e. `Waypoint`).
    */
    public class func create(WKT: String) -> Geometry? {
        let WKTReader = GEOSWKTReader_create_r(GEOS_HANDLE)
        let GEOSGeom = GEOSWKTReader_read_r(GEOS_HANDLE, WKTReader, (WKT as NSString).UTF8String)
        GEOSWKTReader_destroy_r(GEOS_HANDLE, WKTReader)
        return self.create(GEOSGeom)
    }

    /**
    Create a Geometry subclass from its Well Known Binary representation.
    
    :param: WKB The geometry representation in Well Known Binary format.
    :param: size The size of the binary representation in bytes.
    
    :returns: The proper Geometry subclass as parsed from the binary data (i.e. `Waypoint`).
    */
    public class func create(WKB: UnsafePointer<Void>, size: Int)  -> Geometry? {
        let WKBReader = GEOSWKBReader_create_r(GEOS_HANDLE)
        let GEOSGeom = GEOSWKBReader_read_r(GEOS_HANDLE, WKBReader, UnsafePointer<UInt8>(WKB), size)
        GEOSWKBReader_destroy_r(GEOS_HANDLE, WKBReader)
        return self.create(GEOSGeom)
    }
    
    /// The Well Known Text (WKT) representation of the Geometry.
    private(set) public lazy var WKT : String? = {
        let WKTWriter = GEOSWKTWriter_create_r(GEOS_HANDLE)
        GEOSWKTWriter_setTrim_r(GEOS_HANDLE, WKTWriter, 1)
        let wktString = GEOSWKTWriter_write_r(GEOS_HANDLE, WKTWriter, self.geometry)
        let wkt = String.fromCString(wktString)
        free(wktString)
        GEOSWKTWriter_destroy_r(GEOS_HANDLE, WKTWriter)
        return wkt
        
    }()
}

/// Returns true if the two Geometries are exactly equal.
public func ==(lhs: Geometry, rhs: Geometry) -> Bool {
    return GEOSEquals_r(GEOS_HANDLE, lhs.geometry, rhs.geometry) > 0
}

func GEOSGeomFromWKT(handle: GEOSContextHandle_t, WKT: String) -> COpaquePointer {
    let WKTReader = GEOSWKTReader_create_r(handle)
    let GEOSGeom = GEOSWKTReader_read_r(handle, WKTReader, (WKT as NSString).UTF8String)
    GEOSWKTReader_destroy_r(handle, WKTReader)
    return GEOSGeom
}

public struct CoordinatesCollection: SequenceType {
    let geometry: COpaquePointer
    public let count: UInt32
    
    init(geometry: COpaquePointer) {
        self.geometry = geometry

        let sequence = GEOSGeom_getCoordSeq_r(GEOS_HANDLE, self.geometry)
        var numCoordinates: UInt32 = 0
        GEOSCoordSeq_getSize_r(GEOS_HANDLE, sequence, &numCoordinates);
        self.count = numCoordinates
    }
    
    public subscript(index: UInt32) -> Coordinate {
        var x: Double = 0
        var y: Double = 0

        assert(self.count>index, "Index out of bounds")
        let sequence = GEOSGeom_getCoordSeq_r(GEOS_HANDLE, self.geometry)
        GEOSCoordSeq_getX_r(GEOS_HANDLE, sequence, index, &x);
        GEOSCoordSeq_getY_r(GEOS_HANDLE, sequence, index, &y);

        return Coordinate(x: x, y: y)
    }
    
    public func generate() -> GeneratorOf<Coordinate> {
        var index: UInt32 = 0
        return GeneratorOf {
            if index < self.count {
                return self[index++]
            }
            return nil
        }
    }
    
    func map<U>(transform: (Coordinate) -> U) -> [U] {
        var array = Array<U>()
        for coord in self {
            array.append(transform(coord))
        }
        return array
    }
}

public struct GeometriesCollection<T: Geometry>: SequenceType {
    let geometry: COpaquePointer
    public let count: Int32
    
    init(geometry: COpaquePointer) {
        self.geometry = geometry
        self.count = GEOSGetNumGeometries_r (GEOS_HANDLE, geometry)
    }

    public subscript(index: Int32) -> T {
        let GEOSGeom = GEOSGetGeometryN_r(GEOS_HANDLE, self.geometry, index)
        let geom = Geometry.create(GEOSGeom, destroyOnDeinit: false) as! T
        return geom
    }
    
    public func generate() -> GeneratorOf<T> {
        var index: Int32 = 0
        return GeneratorOf {
            if index < self.count {
                return self[index++]
            }
            return nil
        }
    }
    func map<U>(transform: (T) -> U) -> [U] {
        var array = Array<U>()
        for geom in self {
            array.append(transform(geom))
        }
        return array
    }
}

public struct Coordinate {
    public let x: Double
    public let y: Double
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}
