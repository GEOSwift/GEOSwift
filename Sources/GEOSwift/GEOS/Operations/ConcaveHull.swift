import Foundation
import geos

// MARK: - Concave Hull Operations

// Computes a possibly concave geometry that contains all points in the input, allowing
// tighter fitting than a convex hull through a configurable ratio parameter.
//
// ## Z Coordinate Preservation
//
// The dimension of the result depends on the dimension of the input geometry:
// - If the input has Z coordinates, the result will have Z coordinates
// - If the input has no Z coordinates, the result will be XY only
// - M coordinates are never preserved in the result
//
// Examples:
// - XY geometries → XY concave hull
// - XYZ geometries → XYZ concave hull
// - XYM geometries → XY concave hull (M is dropped)
// - XYZM geometries → XYZ concave hull (M is dropped)

public extension GeometryConvertible {
    private func _concaveHull<D: CoordinateType>(withRatio ratio: Double, allowHoles: Bool) throws -> Geometry<D> {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)

        guard let resultPointer = GEOSConcaveHull_r(
            context.handle,
            geosObject.pointer,
            ratio,
            allowHoles ? 1 : 0
        ) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }

        return try Geometry(geosObject: GEOSObject(context: context, pointer: resultPointer))
    }

    /// Computes the concave hull of this geometry.
    ///
    /// See `GEOSConcaveHull_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a0c9888f1483b30d6316555deee0fd3cd).
    ///
    /// - Parameters:
    ///   - ratio: A number between 0 and 1 controlling the concaveness. 0 produces the convex hull,
    ///            1 produces maximum concaveness.
    ///   - allowHoles: Whether to allow holes in the resulting polygon.
    /// - Returns: A concave hull ``Geometry``.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let points = MultiPoint(points: [
    ///     Point(XY(0, 0)), Point(XY(2, 0)),
    ///     Point(XY(2, 2)), Point(XY(0, 2)),
    ///     Point(XY(1, 1))])  // Interior point
    /// let hull = try points.concaveHull(withRatio: 0.5, allowHoles: false)
    /// // Returns a polygon that more closely follows the point distribution
    /// ```
    func concaveHull(withRatio ratio: Double, allowHoles: Bool) throws -> Geometry<XY> {
        return try _concaveHull(withRatio: ratio, allowHoles: allowHoles)
    }

    /// Computes the concave hull of this geometry.
    ///
    /// See `GEOSConcaveHull_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a0c9888f1483b30d6316555deee0fd3cd).
    ///
    /// - Parameters:
    ///   - ratio: A number between 0 and 1 controlling the concaveness. 0 produces the convex hull,
    ///            1 produces maximum concaveness.
    ///   - allowHoles: Whether to allow holes in the resulting polygon.
    /// - Returns: A concave hull ``Geometry`` with XYZ coordinates.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let terrain = MultiPoint(points: [
    ///     Point(XYZ(0, 0, 100)),   // Elevation 100
    ///     Point(XYZ(10, 0, 150)),  // Elevation 150
    ///     Point(XYZ(10, 10, 120)), // Elevation 120
    ///     Point(XYZ(0, 10, 110))])  // Elevation 110
    /// let hull = try terrain.concaveHull(withRatio: 0.5, allowHoles: false)
    /// // Returns XYZ polygon with Z values from the vertices
    /// ```
    func concaveHull(withRatio ratio: Double, allowHoles: Bool) throws -> Geometry<XYZ> where C: HasZ {
        return try _concaveHull(withRatio: ratio, allowHoles: allowHoles)
    }
}
