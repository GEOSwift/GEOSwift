public protocol GeometryConvertible {
    var geometry: Geometry { get }
}

extension Point: GeometryConvertible {
    public var geometry: Geometry {
        .point(self)
    }
}

extension LineString: GeometryConvertible {
    public var geometry: Geometry {
        .lineString(self)
    }
}

extension Polygon.LinearRing: GeometryConvertible {
    // converts LinearRing to LineString
    public var geometry: Geometry {
        .lineString(lineString)
    }
}

extension Polygon: GeometryConvertible {
    public var geometry: Geometry {
        .polygon(self)
    }
}

extension MultiPoint: GeometryConvertible {
    public var geometry: Geometry {
        .multiPoint(self)
    }
}

extension MultiLineString: GeometryConvertible {
    public var geometry: Geometry {
        .multiLineString(self)
    }
}

extension MultiPolygon: GeometryConvertible {
    public var geometry: Geometry {
        .multiPolygon(self)
    }
}

extension GeometryCollection: GeometryConvertible {
    public var geometry: Geometry {
        .geometryCollection(self)
    }
}

extension Geometry: GeometryConvertible {
    public var geometry: Geometry {
        self
    }
}
