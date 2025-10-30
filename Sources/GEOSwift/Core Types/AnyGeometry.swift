import Foundation

/// A coordinate-type-erasing container for `Geometry`.
///
/// This enum allows code to work with geometry types without needing to know their
/// coordinate system (XY, XYZ, XYM, or XYZM) at compile time. Useful for scenarios
/// like error reporting or dynamic geometry handling.
public enum AnyGeometry: Hashable, Sendable {
    case xy(Geometry<XY>)
    case xyz(Geometry<XYZ>)
    case xym(Geometry<XYM>)
    case xyzm(Geometry<XYZM>)

    /// The coordinate dimension of the geometry.
    ///
    /// - XY: 2 dimensions (x, y)
    /// - XYZ: 3 dimensions (x, y, z)
    /// - XYM: 3 dimensions (x, y, m)
    /// - XYZM: 4 dimensions (x, y, z, m)
    public var dimension: Int {
        switch self {
        case .xy: return 2
        case .xyz: return 3
        case .xym: return 3
        case .xyzm: return 4
        }
    }

    /// Whether the geometry has a Z (altitude) coordinate.
    public var hasZ: Bool {
        switch self {
        case .xy, .xym: return false
        case .xyz, .xyzm: return true
        }
    }

    internal init(geosObject: GEOSObject) throws {
        switch (geosObject.hasZ, geosObject.hasM) {
        case (false, false):
            try self.init(Geometry<XY>(geosObject: geosObject))
            return
        case (true, false):
            try self.init(Geometry<XYZ>(geosObject: geosObject))
            return
        case (false, true):
            try self.init(Geometry<XYM>(geosObject: geosObject))
            return
        case (true, true):
            try self.init(Geometry<XYZM>(geosObject: geosObject))
            return
        default:
            throw GEOSwiftError.invalidCoordinates // TODO: Better error?
        }
    }

    /// Whether the geometry has an M (measure) coordinate.
    public var hasM: Bool {
        switch self {
        case .xy, .xyz: return false
        case .xym, .xyzm: return true
        }
    }

    public init(_ geometry: any GeometryConvertible<XY>) {
        self = .xy(geometry.geometry)
    }

    public init(_ geometry: any GeometryConvertible<XYZ>) {
        self = .xyz(geometry.geometry)
    }

    public init(_ geometry: any GeometryConvertible<XYM>) {
        self = .xym(geometry.geometry)
    }

    public init(_ geometry: any GeometryConvertible<XYZM>) {
        self = .xyzm(geometry.geometry)
    }

    /// Converts the geometry to XY coordinates.
    ///
    /// This conversion always succeeds by dropping any Z and/or M coordinates.
    public func asGeometryXY() -> Geometry<XY> {
        switch self {
        case .xy(let geometry):
            return geometry
        case .xyz(let geometry):
            return Geometry(geometry)
        case .xym(let geometry):
            return Geometry(geometry)
        case .xyzm(let geometry):
            return Geometry(geometry)
        }
    }

    /// Converts the geometry to XYZ coordinates.
    ///
    /// - Throws: `GEOSwiftError.cannotConvertCoordinateTypes` if the geometry doesn't have Z coordinates.
    public func asGeometryXYZ() throws -> Geometry<XYZ> {
        switch self {
        case .xyz(let geometry):
            return geometry
        case .xyzm(let geometry):
            return Geometry(geometry)
        case .xy, .xym:
            throw GEOSwiftError.cannotConvertCoordinateTypes
        }
    }

    /// Converts the geometry to XYM coordinates.
    ///
    /// - Throws: `GEOSwiftError.cannotConvertCoordinateTypes` if the geometry doesn't have M coordinates.
    public func asGeometryXYM() throws -> Geometry<XYM> {
        switch self {
        case .xym(let geometry):
            return geometry
        case .xyzm(let geometry):
            return Geometry(geometry)
        case .xy, .xyz:
            throw GEOSwiftError.cannotConvertCoordinateTypes
        }
    }

    /// Converts the geometry to XYZM coordinates.
    ///
    /// - Throws: `GEOSwiftError.cannotConvertCoordinateTypes` if the geometry doesn't have both Z and M coordinates.
    public func asGeometryXYZM() throws -> Geometry<XYZM> {
        switch self {
        case .xyzm(let geometry):
            return geometry
        case .xy, .xyz, .xym:
            throw GEOSwiftError.cannotConvertCoordinateTypes
        }
    }
}
