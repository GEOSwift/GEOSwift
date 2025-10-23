public enum Geometry<C: CoordinateType>: Hashable, Sendable {
    case point(Point<C>)
    case multiPoint(MultiPoint<C>)
    case lineString(LineString<C>)
    case multiLineString(MultiLineString<C>)
    case polygon(Polygon<C>)
    case multiPolygon(MultiPolygon<C>)
    case geometryCollection(GeometryCollection<C>)
}

// MARK: Convenience Methods

public extension Geometry where C == XY {
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
