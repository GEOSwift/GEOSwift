import geos

public protocol SimplicityTestable: GeometryConvertible {
    func isSimple() throws -> Bool
}

extension SimplicityTestable {
    public func isSimple() throws -> Bool {
        try evaluateUnaryPredicate(GEOSisSimple_r)
    }
}

extension Point: SimplicityTestable {}
extension LineString: SimplicityTestable {}
extension Polygon.LinearRing: SimplicityTestable {}
extension Polygon: SimplicityTestable {}
extension MultiPoint: SimplicityTestable {}
extension MultiLineString: SimplicityTestable {}
extension MultiPolygon: SimplicityTestable {}
// GeometryCollection (and by extension, Geometry) is not SimplicityTestable
