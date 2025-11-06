import geos

/// A protocol for geometries that can be tested for closedness.
///
/// A geometry is considered closed if its start and end points are coincident.
///
/// See `GEOSisClosed_r` in the
/// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html).
public protocol ClosednessTestable<C>: GeometryConvertible {
    /// Returns whether this geometry is closed.
    ///
    /// See `GEOSisClosed_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html).
    ///
    /// - Returns: `true` if the geometry is closed, `false` otherwise.
    /// - Throws: `Error` if the closedness test fails.
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
