import geos

public protocol Boundable<C>: GeometryConvertible {
    func boundary() throws -> Geometry<C>
}

extension Boundable {
    public func boundary() throws -> Geometry<C> {
        try performUnaryTopologyOperation(GEOSBoundary_r)
    }
}

extension Point: Boundable {}
extension LineString: Boundable {}
extension Polygon.LinearRing: Boundable {}
extension Polygon: Boundable {}
extension MultiPoint: Boundable {}
extension MultiLineString: Boundable {}
extension MultiPolygon: Boundable {}
// GeometryCollection (and by extension, Geometry) is not Boundable
