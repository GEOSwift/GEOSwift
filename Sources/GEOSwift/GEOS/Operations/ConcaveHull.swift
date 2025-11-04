import Foundation
import geos

// MARK: - Concave Hull Operations

// Concave hull operations for geometric objects.
//
// The concave hull operation computes a possibly concave geometry that contains all points
// in the input geometry. Unlike the convex hull, which is always convex (like stretching a
// rubber band), the concave hull can have indentations and more closely follows the shape
// of the input geometry.
//
// ## Return Types
//
// The concave hull can return different geometry types depending on the input:
// - A point geometry returns a point
// - A line with two points returns a line string
// - Three or more points typically return a polygon (possibly concave)
//
// ## Ratio Parameter
//
// The ratio parameter controls the concaveness of the result:
// - A ratio of 0 produces the convex hull
// - A ratio of 1 produces maximum concaveness
// - Values between 0 and 1 produce intermediate results
// - Higher ratios allow tighter fitting around the input geometry
//
// ## Holes Parameter
//
// The allowHoles parameter controls whether the result can contain holes:
// - When true, the algorithm may create holes in the resulting polygon
// - When false, the result is guaranteed to have no holes
//
// ## Z Coordinate Preservation
//
// When operating on geometries with Z coordinates (XYZ or XYZM), the concave hull operation
// preserves the Z dimension:
// - XY geometries return an XY concave hull
// - XYZ geometries return an XYZ concave hull with Z values from the input geometry
// - XYM geometries return an XY concave hull (M coordinates are not preserved)
// - XYZM geometries return an XYZ concave hull (M coordinates are not preserved)
//
// For geometries with Z coordinates, the Z values of the hull vertices are taken from
// the corresponding vertices in the input geometry.
//
// ## Notes
//
// - The concave hull is always a valid geometry.
// - The operation uses the GEOS library's concave hull algorithm.
// - For polygons with holes, only the exterior shell contributes to the hull.

public extension GeometryConvertible {
    /// Computes the concave hull of this geometry, returning an XY result.
    ///
    /// The concave hull is a possibly concave geometry that contains all points in the input.
    /// The ratio parameter controls how tightly the hull fits the input geometry.
    ///
    /// - Parameters:
    ///   - ratio: A number between 0 and 1 controlling the concaveness. 0 produces the convex hull,
    ///            1 produces maximum concaveness.
    ///   - allowHoles: Whether to allow holes in the resulting polygon.
    /// - Returns: The concave hull as an XY geometry.
    /// - Throws: An error if the operation fails.
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

    /// Computes the concave hull of this geometry with Z coordinates, preserving the Z dimension.
    ///
    /// The concave hull is a possibly concave geometry that contains all points in the input.
    /// Z coordinates from the input geometry are preserved in the result.
    ///
    /// - Parameters:
    ///   - ratio: A number between 0 and 1 controlling the concaveness. 0 produces the convex hull,
    ///            1 produces maximum concaveness.
    ///   - allowHoles: Whether to allow holes in the resulting polygon.
    /// - Returns: The concave hull as an XYZ geometry.
    /// - Throws: An error if the operation fails.
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
    ///
    /// ## Notes
    /// - Available for geometries with Z coordinates (XYZ and XYZM).
    /// - For XYZM geometries, M coordinates are not preserved; only XYZ is returned.
    func concaveHull(withRatio ratio: Double, allowHoles: Bool) throws -> Geometry<XYZ> where C: HasZ {
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
}
