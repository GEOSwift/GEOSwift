import Foundation
import geos

extension GeometryConvertible {
    fileprivate func _intersection<D: CoordinateType, E: CoordinateType>(with geometry: any GeometryConvertible<D>) throws -> Geometry<E>? {
        return try nilIfTooFewPoints {
            try performBinaryTopologyOperation(GEOSIntersection_r, geometry: geometry)
        }
    }
}

public extension GeometryConvertible where C == XY {
    func intersection(with geometry: any GeometryConvertible<XY>) throws -> Geometry<XY>? {
        return try _intersection(with: geometry)
    }
    
    func intersection(with geometry: any GeometryConvertible<XYZ>) throws -> Geometry<XYZ>? {
        return try _intersection(with: geometry)
    }
    
    func intersection(with geometry: any GeometryConvertible<XYM>) throws -> Geometry<XYM>? {
        return try _intersection(with: geometry)
    }
    
    func intersection(with geometry: any GeometryConvertible<XYZM>) throws -> Geometry<XYZM>? {
        return try _intersection(with: geometry)
    }
}

public extension GeometryConvertible where C == XYZ {
    func intersection<D: CoordinateType>(with geometry: any GeometryConvertible<D>) throws -> Geometry<XYZ>? {
        return try _intersection(with: geometry)
    }
    
    func intersection<D: CoordinateType>(with geometry: any GeometryConvertible<D>) throws -> Geometry<XYZM>? where D: HasM {
        return try _intersection(with: geometry)
    }
}

public extension GeometryConvertible where C == XYM {
    func intersection<D: CoordinateType>(with geometry: any GeometryConvertible<D>) throws -> Geometry<XYM>? {
        return try _intersection(with: geometry)
    }
    
    func intersection<D: CoordinateType>(with geometry: any GeometryConvertible<D>) throws -> Geometry<XYZM>? where D: HasZ {
        return try _intersection(with: geometry)
    }
}

public extension GeometryConvertible where C == XYZM {
    func intersection<D: CoordinateType>(with geometry: any GeometryConvertible<D>) throws -> Geometry<XYZM>? {
        return try _intersection(with: geometry)
    }
}
