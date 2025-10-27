/// A type that can represent itself as a ``Geometry``
public protocol GeometryConvertible<C> {
    associatedtype C: CoordinateType

    /// The number of dimensions of the underlying ``CoordinateType``
    var dimension: Int { get }

    /// A flag as to whether the underlying ``CoordinateType`` contains *z* coordinates.
    var hasZ: Bool { get }

    /// A flag as to whether the underlying ``CoordinateType`` contains *m* coordinates.
    var hasM: Bool { get }

    /// The wrapped ``Geometry`` value
    var geometry: Geometry<C> { get }
}

public extension GeometryConvertible {
    var dimension: Int { C.dimension }
    var hasZ: Bool { C.hasZ }
    var hasM: Bool { C.hasM }
}

extension Point: GeometryConvertible {
    public var geometry: Geometry<C> {
        .point(self)
    }
}

extension LineString: GeometryConvertible {
    public var geometry: Geometry<C> {
        .lineString(self)
    }
}

extension Polygon.LinearRing: GeometryConvertible {
    // converts LinearRing to LineString
    public var geometry: Geometry<C> {
        .lineString(lineString)
    }
}

extension Polygon: GeometryConvertible {
    public var geometry: Geometry<C> {
        .polygon(self)
    }
}

extension MultiPoint: GeometryConvertible {
    public var geometry: Geometry<C> {
        .multiPoint(self)
    }
}

extension MultiLineString: GeometryConvertible {
    public var geometry: Geometry<C> {
        .multiLineString(self)
    }
}

extension MultiPolygon: GeometryConvertible {
    public var geometry: Geometry<C> {
        .multiPolygon(self)
    }
}

extension GeometryCollection: GeometryConvertible {
    public var geometry: Geometry<C> {
        .geometryCollection(self)
    }
}

extension Geometry: GeometryConvertible {
    public var geometry: Geometry {
        self
    }
}
