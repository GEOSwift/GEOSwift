public protocol GeometryConvertible<C> {
    associatedtype C: CoordinateType
    
    var dimension: Int { get }
    var hasZ: Bool { get }
    var hasM: Bool { get }
    
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
