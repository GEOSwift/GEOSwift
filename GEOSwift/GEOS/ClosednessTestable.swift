import geos

public protocol ClosednessTestable: GeometryConvertible {
    func isClosed() throws -> Bool
}

extension ClosednessTestable {
    public func isClosed() throws -> Bool {
        try evaluateUnaryPredicate(GEOSisClosed_r)
    }
}

// Point is not ClosednessTestable
extension LineString: ClosednessTestable {}
extension Polygon.LinearRing: ClosednessTestable {}
// Polygon is not ClosednessTestable
// MultiPoint is not ClosednessTestable
extension MultiLineString: ClosednessTestable {}
// MultiPolygon is not ClosednessTestable
// GeometryCollection (and by extension, Geometry) is not ClosednessTestable
