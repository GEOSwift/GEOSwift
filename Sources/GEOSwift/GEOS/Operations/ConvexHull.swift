import Foundation
import geos

// MARK: - Convex Hull Operations

// Computes the smallest convex geometry that contains all points in the input geometry.
//
// ## Z Coordinate Preservation
//
// The dimension of the result depends on the dimension of the input geometry:
// - If the input has Z coordinates, the result will have Z coordinates
// - If the input has no Z coordinates, the result will be XY only
// - M coordinates are never preserved in the result
//
// Examples:
// - XY geometries → XY convex hull
// - XYZ geometries → XYZ convex hull
// - XYM geometries → XY convex hull (M is dropped)
// - XYZM geometries → XYZ convex hull (M is dropped)

public extension GeometryConvertible {
    /// Computes the convex hull of this geometry.
    ///
    /// See `GEOSConvexHull_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#ab600860dbecf029f421c69c17579d363).
    ///
    /// - Returns: A convex hull ``Geometry``.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let points = MultiPoint(points: [
    ///     Point(XY(0, 0)), Point(XY(1, 0)),
    ///     Point(XY(1, 1)), Point(XY(0, 1)),
    ///     Point(XY(0.5, 0.5))])  // Interior point
    /// let hull = try points.convexHull()
    /// // Returns a geometry with vertices at the four corner points
    /// ```
    func convexHull() throws -> Geometry<XY> {
        try performUnaryTopologyOperation(GEOSConvexHull_r)
    }

    /// Computes the convex hull of this geometry.
    ///
    /// See `GEOSConvexHull_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#ab600860dbecf029f421c69c17579d363).
    ///
    /// - Returns: A convex hull ``Geometry`` with XYZ coordinates.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let terrain = try Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XYZ(0, 0, 100),   // Elevation 100
    ///     XYZ(10, 0, 150),  // Elevation 150
    ///     XYZ(5, 5, 120),   // Interior point at elevation 120
    ///     XYZ(0, 10, 110),  // Elevation 110
    ///     XYZ(0, 0, 100)]))
    /// let hull = try terrain.convexHull()
    /// // Returns XYZ geometry with Z values from the outer vertices
    /// ```
    func convexHull() throws -> Geometry<XYZ> where C: HasZ {
        try performUnaryTopologyOperation(GEOSConvexHull_r)
    }
}
