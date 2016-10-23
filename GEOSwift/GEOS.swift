//
//  GEOS.swift
//
//  Created by Andrea Cremaschi on 26/04/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

import Foundation

typealias GEOSCallbackFunction = @convention(c) (UnsafeMutableRawPointer) -> Void

let swiftCallback : GEOSCallbackFunction = { args -> Void in
    if let string = String(validatingUTF8: unsafeBitCast(args, to: UnsafeMutablePointer<CChar>.self)) {
        print("GEOSwift # " + string + ".")
    }
}

var GEOS_HANDLE: OpaquePointer = {
//    return initGEOSWrapper_r();
    return initGEOS_r(unsafeBitCast(swiftCallback, to: GEOSMessageHandler.self),
        unsafeBitCast(swiftCallback, to: GEOSMessageHandler.self))
}()

public typealias CoordinateDegrees = Double

/// A base abstract geometry class
// Geometry is a model data type, so a struct would be a better fit, but it is actually a wrapper of GEOS native objects,
// that are in fact C pointers, and structs in Swift don't have a dealloc where one can release allocated memory.
// Furthermore, being a class Geometry can inherit from NSObject so that debugQuickLookObject() can be implemented
@objc open class Geometry : NSObject {

    let geometry: OpaquePointer
    internal let destroyOnDeinit: Bool
    
    required public init(GEOSGeom: OpaquePointer, destroyOnDeinit: Bool) {
        self.geometry = GEOSGeom
        self.destroyOnDeinit = destroyOnDeinit
    }

    deinit {
        if (self.destroyOnDeinit) {
            GEOSGeom_destroy_r(GEOS_HANDLE, geometry);
        }
    }
    
    internal convenience init(GEOSGeom: OpaquePointer) {
        self.init(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
    }

    internal class func create(_ GEOSGeom: OpaquePointer, destroyOnDeinit: Bool) -> Geometry? {
        guard let subclass = Geometry.classForGEOSGeom(GEOSGeom) else {
            return nil
        }
        return subclass.init(GEOSGeom: GEOSGeom, destroyOnDeinit: destroyOnDeinit)
    }
    
    open class func geometryTypeId() -> Int32 {
        return -1 // Abstract
    }
    
    internal class func classForGEOSGeom(_ GEOSGeom: OpaquePointer) -> Geometry.Type? {
        let geometryTypeId = GEOSGeomTypeId_r(GEOS_HANDLE, GEOSGeom)
        var subclass: Geometry.Type

        switch UInt32(geometryTypeId) {
        case GEOS_POINT.rawValue:
            subclass = Waypoint.self
            
        case GEOS_LINESTRING.rawValue:
            subclass = LineString.self
            
        case GEOS_LINEARRING.rawValue:
            subclass = LinearRing.self
            
        case GEOS_POLYGON.rawValue:
            subclass = Polygon.self
            
        case GEOS_MULTIPOINT.rawValue:
            subclass = MultiPoint.self
            
        case GEOS_MULTILINESTRING.rawValue:
            subclass = MultiLineString.self
            
        case GEOS_MULTIPOLYGON.rawValue:
            subclass = MultiPolygon.self
            
        case GEOS_GEOMETRYCOLLECTION.rawValue:
            subclass = GeometryCollection<Geometry>.self
            
        default:
            return nil
        }
        return subclass
    }
    
    fileprivate class func create(_ GEOSGeom: OpaquePointer) -> Geometry? {
        return self.create(GEOSGeom, destroyOnDeinit: true)
    }

    /**
    Create a Geometry subclass from its Well Known Text representation.
    
    - parameter WKT: The geometry representation in Well Known Text format (i.e. `POINT(10 45)`).
    
    - returns: The proper Geometry subclass as parsed from the string (i.e. `Waypoint`).
    */
    open class func create(_ WKT: String) -> Geometry? {
        let WKTReader = GEOSWKTReader_create_r(GEOS_HANDLE)
        defer { GEOSWKTReader_destroy_r(GEOS_HANDLE, WKTReader) }
        guard let GEOSGeom = GEOSWKTReader_read_r(GEOS_HANDLE, WKTReader, (WKT as NSString).utf8String) else {
            return nil
        }
        return self.create(GEOSGeom)
    }

    /**
    Create a Geometry subclass from its Well Known Binary representation.
    
    - parameter WKB: The geometry representation in Well Known Binary format.
    - parameter size: The size of the binary representation in bytes.
    
    - returns: The proper Geometry subclass as parsed from the binary data (i.e. `Waypoint`).
    */
    open class func create(_ WKB: UnsafePointer<UInt8>, size: Int)  -> Geometry? {
        let WKBReader = GEOSWKBReader_create_r(GEOS_HANDLE)
        defer { GEOSWKBReader_destroy_r(GEOS_HANDLE, WKBReader) }
        guard let GEOSGeom = GEOSWKBReader_read_r(GEOS_HANDLE, WKBReader, WKB, size) else {
            return nil
        }
        return self.create(GEOSGeom)
    }
    
    /// The Well Known Text (WKT) representation of the Geometry.
    fileprivate(set) open lazy var WKT : String? = {
        let WKTWriter = GEOSWKTWriter_create_r(GEOS_HANDLE)
        GEOSWKTWriter_setTrim_r(GEOS_HANDLE, WKTWriter, 1)
        guard let wktString = GEOSWKTWriter_write_r(GEOS_HANDLE, WKTWriter, self.geometry) else {
            return nil
        }
        let wkt = String(cString: wktString)
        free(wktString)
        GEOSWKTWriter_destroy_r(GEOS_HANDLE, WKTWriter)
        return wkt
        
    }()
}

/// Returns true if the two Geometries are exactly equal.
public func ==(lhs: Geometry, rhs: Geometry) -> Bool {
    return GEOSEquals_r(GEOS_HANDLE, lhs.geometry, rhs.geometry) > 0
}

func GEOSGeomFromWKT(_ handle: GEOSContextHandle_t, WKT: String) -> OpaquePointer? {
    let WKTReader = GEOSWKTReader_create_r(handle)
    let GEOSGeom = GEOSWKTReader_read_r(handle, WKTReader, (WKT as NSString).utf8String)
    GEOSWKTReader_destroy_r(handle, WKTReader)
    return GEOSGeom
}

public struct CoordinatesCollection: Sequence {
    let geometry: OpaquePointer
    public let count: UInt32
    
    init(geometry: OpaquePointer) {
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
    
    public func makeIterator() -> AnyIterator<Coordinate> {
        var index: UInt32 = 0
        return AnyIterator {
            guard index < self.count else { return nil }
            let item = self[index]
            index += 1
            return item
        }
    }
    
    public func map<U>(_ transform: (Coordinate) -> U) -> [U] {
        var array = Array<U>()
        for coord in self {
            array.append(transform(coord))
        }
        return array
    }
}

public struct GeometriesCollection<T: Geometry>: Sequence {
    let geometry: OpaquePointer
    public let count: Int32
    
    init(geometry: OpaquePointer) {
        self.geometry = geometry
        self.count = GEOSGetNumGeometries_r (GEOS_HANDLE, geometry)
    }

    public subscript(index: Int32) -> T {
        let GEOSGeom = GEOSGetGeometryN_r(GEOS_HANDLE, self.geometry, index)!
        let geom = Geometry.create(GEOSGeom, destroyOnDeinit: false) as! T
        return geom
    }
    
    public func makeIterator() -> AnyIterator<T> {
        var index: Int32 = 0
        return AnyIterator {
            guard index < self.count else { return nil }
            let item = self[index]
            index += 1
            return item
        }
    }
    
    public func map<U>(_ transform: (T) -> U) -> [U] {
        var array = Array<U>()
        for geom in self {
            array.append(transform(geom))
        }
        return array
    }
}

public struct Coordinate {
    public let x: CoordinateDegrees
    public let y: CoordinateDegrees
    public init(x: CoordinateDegrees, y: CoordinateDegrees) {
        self.x = x
        self.y = y
    }
}
