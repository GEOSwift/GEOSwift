import Foundation
import geos

// MARK: - Prepared Geometry Operations

// Prepared geometries are optimized for repeated spatial operations. When you need to perform
// many operations (like contains, intersects, covers) against the same geometry, preparing it
// first can provide significant performance improvements by building internal spatial indexes.

public extension GeometryConvertible {
    /// Creates a prepared geometry for optimized spatial operations.
    ///
    /// A prepared geometry builds internal spatial indexes that accelerate repeated binary
    /// predicates (contains, intersects, covers, etc.) when used as the first operand.
    /// This is particularly beneficial when testing many geometries against a single base geometry.
    ///
    /// See `GEOSPrepare_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#aba492e4cda91265b13f11345beb8471f).
    ///
    /// - Returns: A ``PreparedGeometry`` for optimized spatial operations.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let searchArea = try! Polygon(coordinates: [
    ///     XY(0, 0), XY(10, 0), XY(10, 10), XY(0, 10), XY(0, 0)])
    /// let prepared = try searchArea.makePrepared()
    ///
    /// // Test many points efficiently
    /// let points = [XY(1, 1), XY(5, 5), XY(20, 20)]
    /// for point in points {
    ///     let pointGeometry = try Point(coordinate: point)
    ///     if try prepared.contains(pointGeometry) {
    ///         print("Point \(point) is inside search area")
    ///     }
    /// }
    /// ```
    func makePrepared() throws -> PreparedGeometry<C> {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)

        return try PreparedGeometry(context: context, base: geosObject)
    }
}
