import Foundation
import geos

// MARK: - Simplify Operations

// Simplifies geometries by removing vertices that are co-linear within a tolerance distance
// using the Douglas-Peucker algorithm.
//
// ## Z Coordinate Preservation
//
// The dimension of the result depends on the dimension of the input geometry:
// - If the input has Z coordinates, the result will have Z coordinates
// - If the input has no Z coordinates, the result will be XY only
// - M coordinates are never preserved in the result
//
// Examples:
// - XY geometries → XY simplified geometry
// - XYZ geometries → XYZ simplified geometry
// - XYM geometries → XY simplified geometry (M is dropped)
// - XYZM geometries → XYZ simplified geometry (M is dropped)

public extension GeometryConvertible {
    private func _simplify<D: CoordinateType>(withTolerance tolerance: Double) throws -> Geometry<D> {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)

        guard let resultPointer = GEOSSimplify_r(context.handle, geosObject.pointer, tolerance) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }

        return try Geometry(geosObject: GEOSObject(context: context, pointer: resultPointer))
    }

    /// Simplifies the geometry using the Douglas-Peucker algorithm.
    ///
    /// See `GEOSSimplify_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a72a95e84dca6684b79860c1e1ab09c9c).
    ///
    /// - Parameter tolerance: The distance tolerance for simplification. Vertices closer than this
    ///   distance to the simplified line segments will be removed.
    /// - Returns: A simplified ``Geometry``.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let lineString = try! LineString(coordinates: [
    ///     XY(0, 0), XY(1, 0.1), XY(2, -0.1), XY(3, 0)])
    /// let simplified = try lineString.simplify(withTolerance: 0.5)
    /// // Returns a geometry with fewer vertices
    /// ```
    func simplify(withTolerance tolerance: Double) throws -> Geometry<XY> {
        return try _simplify(withTolerance: tolerance)
    }
}

public extension GeometryConvertible where C: HasZ {
    /// Simplifies the geometry using the Douglas-Peucker algorithm.
    ///
    /// See `GEOSSimplify_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a72a95e84dca6684b79860c1e1ab09c9c).
    ///
    /// - Parameter tolerance: The distance tolerance for simplification. Vertices closer than this
    ///   distance to the simplified line segments will be removed.
    /// - Returns: A simplified ``Geometry`` with XYZ coordinates.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let lineString = try! LineString(coordinates: [
    ///     XYZ(0, 0, 10), XYZ(1, 0.1, 20), XYZ(2, -0.1, 30), XYZ(3, 0, 40)])
    /// let simplified = try lineString.simplify(withTolerance: 0.5)
    /// // Returns a geometry with fewer vertices, preserving Z coordinates
    /// ```
    func simplify(withTolerance tolerance: Double) throws -> Geometry<XYZ> {
        return try _simplify(withTolerance: tolerance)
    }
}
