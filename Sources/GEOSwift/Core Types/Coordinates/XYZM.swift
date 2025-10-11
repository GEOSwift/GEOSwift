import Foundation
import geos

public struct XYZM: CoordinateType, HasZ, HasM {
    
    // MARK: Public API
    
    public static let dimension = 4
    public static let hasZ = true
    public static let hasM = true
    
    public var x: Double
    public var y: Double
    public var z: Double
    public var m: Double
    
    public var values: [Double] { [x, y, z, m] }
    
    public init(_ x: Double, _ y: Double, _ z: Double, _ m: Double) {
        self.x = x
        self.y = y
        self.z = z
        self.m = m
    }
    
    public init<C: CoordinateType>(_ coordinate: C) where C: HasZ & HasM {
        self.x = coordinate.x
        self.y = coordinate.y
        self.z = coordinate.z
        self.m = coordinate.m
    }
    
    // MARK: Codable
    
    // TODO: Add flag to enable/disable M-coordinate encoding/decoding since its technically not allowed by the official GeoJSON support, though many implementations do it anyway to match WKT/WKB and spatial dbs.
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let values = try container.decode([Double].self)
        guard values.count == 4 else {
            throw GEOSwiftError.invalidCoordinates
        }
        
        self.x = values[0]
        self.y = values[1]
        self.z = values[2]
        self.m = values[3]
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(values)
    }
    
    // MARK: Internal API
    
    public static let bridge = GeosCoordinateBridge(
        getter: { (context, seq, idx) in
            var x: Double = 0
            var y: Double = 0
            var z: Double = 0
            var m: Double = 0
            
            guard GEOSCoordSeq_getXYZ_r(context.handle, seq, UInt32(idx), &x, &y, &z) != 0 else {
                throw GEOSError.libraryError(errorMessages: context.errors)
            }
            
            guard GEOSCoordSeq_getM_r(context.handle, seq, UInt32(idx), &m) != 0 else {
                throw GEOSError.libraryError(errorMessages: context.errors)
            }
            
            return XYZM(x, y, z, m)
        },
        setter: { (context, seq, idx, coord) in
            guard GEOSCoordSeq_setXYZ_r(context.handle, seq, UInt32(idx), coord.x, coord.y, coord.z) != 0 else {
                throw GEOSError.libraryError(errorMessages: context.errors)
            }
            
            guard GEOSCoordSeq_setM_r(context.handle, seq, UInt32(idx), coord.m) != 0 else {
                throw GEOSError.libraryError(errorMessages: context.errors)
            }
        }
    )
}
