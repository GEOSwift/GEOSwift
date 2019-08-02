import geos

public protocol Boundable: GeometryConvertible {
    func boundary() throws -> Geometry
}

extension Boundable {
    public func boundary() throws -> Geometry {
        return try performUnaryTopologyOperation(GEOSBoundary_r)
    }
}

extension Point: Boundable {}
extension LineString: Boundable {}
extension Polygon.LinearRing: Boundable {}
extension Polygon: Boundable {}
extension MultiPoint: Boundable {}
extension MultiLineString: Boundable {}
extension MultiPolygon: Boundable {}
// GeometryCollection (and by extension, Geometry) are not Boundable
