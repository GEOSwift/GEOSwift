import Foundation
import geos

// MARK: - Snap Operations

// Snaps the vertices and segments of a geometry to the vertices of a reference geometry within
// a specified tolerance, using heuristics to avoid creating invalid topologies.
//
// ## Z Coordinate Preservation
//
// The dimension of the result depends on the dimension of the input geometry:
// - If the input has Z coordinates, the result will have Z coordinates
// - If the input has no Z coordinates, the result will be XY only
// - M coordinates are never preserved in the result
//
// Examples:
// - XY geometries → XY snapped geometry
// - XYZ geometries → XYZ snapped geometry
// - XYM geometries → XY snapped geometry (M is dropped)
// - XYZM geometries → XYZ snapped geometry (M is dropped)

public extension GeometryConvertible {
    private func _snap<D: CoordinateType>(
        to geometry: any GeometryConvertible<C>,
        tolerance: Double
    ) throws -> Geometry<D> {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let otherGeosObject = try geometry.geometry.geosObject(with: context)

        guard let pointer = GEOSSnap_r(
            context.handle,
            geosObject.pointer,
            otherGeosObject.pointer,
            tolerance
        ) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }

        return try Geometry(geosObject: GEOSObject(context: context, pointer: pointer))
    }

    /// Snaps the vertices and segments of this geometry to the vertices of another geometry.
    ///
    /// Heuristics are used to determine which vertices to snap to avoid creating invalid topologies.
    /// Some potential snaps within the tolerance may be omitted for safety.
    ///
    /// See `GEOSSnap_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a6e5efd34016d94bf5dfe73301e10162f).
    ///
    /// - Parameters:
    ///   - geometry: The reference geometry to snap to.
    ///   - tolerance: The maximum distance for snapping vertices.
    /// - Returns: A snapped ``Geometry``.
    /// - Throws: `Error` if the operation fails.
    ///
    /// - Note: The caller is responsible for checking that the result is valid, as snap operations
    ///   do not guarantee valid output geometries.
    ///
    /// ## Example
    /// ```swift
    /// let line1 = try! LineString(coordinates: [XY(0, 0), XY(10, 0)])
    /// let line2 = try! LineString(coordinates: [XY(0, 0.5), XY(10, 0)])
    /// let snapped = try line1.snap(to: line2, tolerance: 1.0)
    /// // line1's vertices snap to line2's vertices within tolerance
    /// ```
    func snap(to geometry: any GeometryConvertible<C>, tolerance: Double) throws -> Geometry<XY> {
        return try _snap(to: geometry, tolerance: tolerance)
    }
}

public extension GeometryConvertible where C: HasZ {
    /// Snaps the vertices and segments of this geometry to the vertices of another geometry.
    ///
    /// Heuristics are used to determine which vertices to snap to avoid creating invalid topologies.
    /// Some potential snaps within the tolerance may be omitted for safety.
    ///
    /// See `GEOSSnap_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a6e5efd34016d94bf5dfe73301e10162f).
    ///
    /// - Parameters:
    ///   - geometry: The reference geometry to snap to.
    ///   - tolerance: The maximum distance for snapping vertices.
    /// - Returns: A snapped ``Geometry`` with XYZ coordinates.
    /// - Throws: `Error` if the operation fails.
    ///
    /// - Note: The caller is responsible for checking that the result is valid, as snap operations
    ///   do not guarantee valid output geometries.
    ///
    /// ## Example
    /// ```swift
    /// let line1 = try! LineString(coordinates: [XYZ(0, 0, 10), XYZ(10, 0, 20)])
    /// let line2 = try! LineString(coordinates: [XYZ(0, 0.5, 15), XYZ(10, 0, 25)])
    /// let snapped = try line1.snap(to: line2, tolerance: 1.0)
    /// // line1's vertices snap to line2's vertices, preserving Z coordinates
    /// ```
    func snap(to geometry: any GeometryConvertible<C>, tolerance: Double) throws -> Geometry<XYZ> {
        return try _snap(to: geometry, tolerance: tolerance)
    }
}
