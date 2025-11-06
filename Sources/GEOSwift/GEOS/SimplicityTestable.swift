import geos

/// A protocol for geometries that can be tested for simplicity.
///
/// A geometry is simple if it has no self-intersections or anomalous points.
///
/// See `GEOSisSimple_r` in the
/// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html).
public protocol SimplicityTestable: GeometryConvertible {
    /// Returns whether this geometry is simple.
    ///
    /// See `GEOSisSimple_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html).
    ///
    /// - Returns: `true` if the geometry is simple, `false` otherwise.
    /// - Throws: `Error` if the simplicity test fails.
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
