/// A geometry value that can represent any of the seven OGC geometry types.
///
/// The underlying ``CoordinateType`` (e.g. ``XY``, ``XYZ``) determines the dimensionality.
public enum Geometry<C: CoordinateType>: Hashable, Sendable {
    /// A ``Point`` geometry
    case point(Point<C>)
    /// A ``MultiPoint`` geometry
    case multiPoint(MultiPoint<C>)
    /// A ``LineString`` geometry
    case lineString(LineString<C>)
    /// A ``MultiLineString`` geometry
    case multiLineString(MultiLineString<C>)
    /// A ``Polygon`` geometry
    case polygon(Polygon<C>)
    /// A ``MultiPolygon`` geometry
    case multiPolygon(MultiPolygon<C>)
    /// A ``GeometryCollection`` geometry
    case geometryCollection(GeometryCollection<C>)
    
    func asXY() -> Geometry<XY> where C == XY {
        return self
    }
    
    func asXY() -> Geometry<XY> {
        return Geometry<XY>(self)
    }
}

// MARK: Convenience Methods

public extension Geometry where C == XY {
    /// Initialize a `Geometry<XY>` from another `Geometry`.
    /// - parameters:
    ///   - geometry: The geometry to copy from.
    init<D: CoordinateType>(_ geometry: Geometry<D>) {
        switch geometry {
        case .point(let point):
            self = .point(Point<XY>(point))
        case .multiPoint(let multiPoint):
            self = .multiPoint(MultiPoint<XY>(multiPoint))
        case .lineString(let lineString):
            self = .lineString(LineString<XY>(lineString))
        case .multiLineString(let multiLineString):
            self = .multiLineString(MultiLineString<XY>(multiLineString))
        case .polygon(let polygon):
            self = .polygon(Polygon<XY>(polygon))
        case .multiPolygon(let multiPolygon):
            self = .multiPolygon(MultiPolygon<XY>(multiPolygon))
        case .geometryCollection(let collection):
            self = .geometryCollection(GeometryCollection<XY>(collection))
        }
    }
}

public extension Geometry where C == XYZ {
    /// Initialize a `Geometry<XYZ>` from another `Geometry` with Z coordinates.
    /// - parameters:
    ///   - geometry: The geometry to copy from.
    init<D: CoordinateType & HasZ>(_ geometry: Geometry<D>) {
        switch geometry {
        case .point(let point):
            self = .point(Point<XYZ>(point))
        case .multiPoint(let multiPoint):
            self = .multiPoint(MultiPoint<XYZ>(multiPoint))
        case .lineString(let lineString):
            self = .lineString(LineString<XYZ>(lineString))
        case .multiLineString(let multiLineString):
            self = .multiLineString(MultiLineString<XYZ>(multiLineString))
        case .polygon(let polygon):
            self = .polygon(Polygon<XYZ>(polygon))
        case .multiPolygon(let multiPolygon):
            self = .multiPolygon(MultiPolygon<XYZ>(multiPolygon))
        case .geometryCollection(let collection):
            self = .geometryCollection(GeometryCollection<XYZ>(collection))
        }
    }
}

public extension Geometry where C == XYZM {
    /// Initialize a `Geometry<XYZM>` from another `Geometry` with Z and M coordinates.
    /// - parameters:
    ///   - geometry: The geometry to copy from.
    init<D: CoordinateType & HasZ & HasM>(_ geometry: Geometry<D>) {
        switch geometry {
        case .point(let point):
            self = .point(Point<XYZM>(point))
        case .multiPoint(let multiPoint):
            self = .multiPoint(MultiPoint<XYZM>(multiPoint))
        case .lineString(let lineString):
            self = .lineString(LineString<XYZM>(lineString))
        case .multiLineString(let multiLineString):
            self = .multiLineString(MultiLineString<XYZM>(multiLineString))
        case .polygon(let polygon):
            self = .polygon(Polygon<XYZM>(polygon))
        case .multiPolygon(let multiPolygon):
            self = .multiPolygon(MultiPolygon<XYZM>(multiPolygon))
        case .geometryCollection(let collection):
            self = .geometryCollection(GeometryCollection<XYZM>(collection))
        }
    }
}

public extension Geometry where C == XYM {
    /// Initialize a `Geometry<XYM>` from another `Geometry` with M coordinates.
    /// - parameters:
    ///   - geometry: The geometry to copy from.
    init<D: CoordinateType & HasM>(_ geometry: Geometry<D>) {
        switch geometry {
        case .point(let point):
            self = .point(Point<XYM>(point))
        case .multiPoint(let multiPoint):
            self = .multiPoint(MultiPoint<XYM>(multiPoint))
        case .lineString(let lineString):
            self = .lineString(LineString<XYM>(lineString))
        case .multiLineString(let multiLineString):
            self = .multiLineString(MultiLineString<XYM>(multiLineString))
        case .polygon(let polygon):
            self = .polygon(Polygon<XYM>(polygon))
        case .multiPolygon(let multiPolygon):
            self = .multiPolygon(MultiPolygon<XYM>(multiPolygon))
        case .geometryCollection(let collection):
            self = .geometryCollection(GeometryCollection<XYM>(collection))
        }
    }
}
