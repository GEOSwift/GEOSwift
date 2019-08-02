public protocol GeometryConvertible {
    var geometry: Geometry { get }
}

extension Point: GeometryConvertible {
    public var geometry: Geometry {
        return .point(self)
    }
}

extension LineString: GeometryConvertible {
    public var geometry: Geometry {
        return .lineString(self)
    }
}

extension Polygon.LinearRing: GeometryConvertible {
    // converts LinearRing to LineString
    public var geometry: Geometry {
        return .lineString(lineString)
    }
}

extension Polygon: GeometryConvertible {
    public var geometry: Geometry {
        return .polygon(self)
    }
}

extension MultiPoint: GeometryConvertible {
    public var geometry: Geometry {
        return .multiPoint(self)
    }
}

extension MultiLineString: GeometryConvertible {
    public var geometry: Geometry {
        return .multiLineString(self)
    }
}

extension MultiPolygon: GeometryConvertible {
    public var geometry: Geometry {
        return .multiPolygon(self)
    }
}

extension GeometryCollection: GeometryConvertible {
    public var geometry: Geometry {
        return .geometryCollection(self)
    }
}

extension Geometry: GeometryConvertible {
    public var geometry: Geometry {
        return self
    }
}
