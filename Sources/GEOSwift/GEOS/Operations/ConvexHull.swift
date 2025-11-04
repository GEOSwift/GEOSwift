import Foundation
import geos

// MARK: - Convex Hull Operations

// Convex hull operations for geometric objects.
//
// The convex hull operation computes the smallest convex polygon that contains all points
// in the input geometry. Think of it as stretching a rubber band around the geometry's outermost points.
//
// ## Return Types
//
// The convex hull can return different geometry types depending on the input:
// - A point geometry returns a point
// - A line with two points returns a line string
// - Three or more non-collinear points return a polygon
// - Collinear points return a line string
//
// ## Z Coordinate Preservation
//
// When operating on geometries with Z coordinates (XYZ or XYZM), the convex hull operation
// preserves the Z dimension:
// - XY geometries return an XY convex hull
// - XYZ geometries return an XYZ convex hull with Z values from the input geometry
// - XYM geometries return an XY convex hull (M coordinates are not preserved)
// - XYZM geometries return an XYZ convex hull (M coordinates are not preserved)
//
// For geometries with Z coordinates, the Z values of the hull vertices are taken from
// the corresponding vertices in the input geometry. Interior points do not contribute to
// the hull, so their Z values are not used.
//
// ## Notes
//
// - The convex hull is always a valid geometry.
// - The operation follows the OGC Simple Features specification.
// - For polygons with holes, only the exterior shell contributes to the hull.

public extension GeometryConvertible {
    /// Computes the convex hull of this geometry, returning an XY result.
    ///
    /// The convex hull is the smallest convex polygon that contains all points in the geometry.
    ///
    /// - Returns: The convex hull as an XY geometry.
    /// - Throws: An error if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let points = MultiPoint(points: [
    ///     Point(XY(0, 0)), Point(XY(1, 0)),
    ///     Point(XY(1, 1)), Point(XY(0, 1)),
    ///     Point(XY(0.5, 0.5))])  // Interior point
    /// let hull = try points.convexHull()
    /// // Returns a polygon with vertices at the four corner points
    /// ```
    func convexHull() throws -> Geometry<XY> {
        try performUnaryTopologyOperation(GEOSConvexHull_r)
    }

    /// Computes the convex hull of this geometry with Z coordinates, preserving the Z dimension.
    ///
    /// The convex hull is the smallest convex polygon that contains all points in the geometry.
    /// Z coordinates from the input geometry are preserved in the result.
    ///
    /// - Returns: The convex hull as an XYZ geometry.
    /// - Throws: An error if the operation fails.
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
    /// // Returns XYZ polygon with Z values from the outer vertices
    /// ```
    ///
    /// ## Notes
    /// - Available for geometries with Z coordinates (XYZ and XYZM).
    /// - For XYZM geometries, M coordinates are not preserved; only XYZ is returned.
    /// - Interior points do not contribute to the convex hull and their Z values are not used.
    func convexHull() throws -> Geometry<XYZ> where C: HasZ {
        try performUnaryTopologyOperation(GEOSConvexHull_r)
    }
}
