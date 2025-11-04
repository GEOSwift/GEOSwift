import Foundation
import geos

// MARK: - Symmetric Difference Operations

// Computes a geometry representing the points that are in either geometry but not in both.
//
// ## Z Coordinate Preservation
//
// The dimension of the result depends on the dimensions of both input geometries:
// - If EITHER operand has Z coordinates, the result will have Z coordinates
// - If NEITHER operand has Z coordinates, the result will be XY only
// - M coordinates are never preserved in the result
//
// Examples:
// - XY.symmetricDifference(XY) → XY result
// - XY.symmetricDifference(XYZ) → XYZ result (second operand has Z)
// - XYZ.symmetricDifference(XY) → XYZ result (first operand has Z)
// - XYZ.symmetricDifference(XYZ) → XYZ result (both have Z)
// - XYM.symmetricDifference(XYM) → XY result (M is not preserved)
// - XYZM.symmetricDifference(XY) → XYZ result (first has Z, M is dropped)
//
// For geometries with Z coordinates, Z values are taken from the corresponding
// vertices in the input geometries. When new vertices are created through intersection,
// Z values are interpolated.

public extension GeometryConvertible {
    /// Computes the symmetric difference between this geometry and another.
    ///
    /// See `GEOSSymDifference_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a5c11e43cddf600366cff2a9cab98c53d).
    ///
    /// - Parameter geometry: The geometry to compute symmetric difference with (any dimension).
    /// - Returns: The symmetric difference as a ``Geometry``, or `nil` if the result is empty or has too few points.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let rect1 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XY(0, 0), XY(2, 0), XY(2, 2), XY(0, 2), XY(0, 0)]))
    /// let rect2 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XY(1, 1), XY(3, 1), XY(3, 3), XY(1, 3), XY(1, 1)]))
    /// let symDiff = try rect1.symmetricDifference(with: rect2)
    /// // Returns the two non-overlapping regions (rect1 and rect2 minus their intersection)
    /// ```
    func symmetricDifference<D: CoordinateType>(
        with geometry: any GeometryConvertible<D>
    ) throws -> Geometry<XY>? {
        return try nilIfTooFewPoints {
            try performBinaryTopologyOperation(GEOSSymDifference_r, geometry: geometry)
        }
    }

    /// Computes the symmetric difference between this geometry and another.
    ///
    /// See `GEOSSymDifference_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a5c11e43cddf600366cff2a9cab98c53d).
    ///
    /// - Parameter geometry: The geometry with Z coordinates to compute symmetric difference with.
    /// - Returns: The symmetric difference as a ``Geometry`` with XYZ coordinates, or `nil` if the result is empty or
    ///   has too few points.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// // XY geometry symmetric difference with XYZ geometry returns XYZ
    /// let flatRect = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XY(0, 0), XY(10, 0), XY(10, 10), XY(0, 10), XY(0, 0)]))
    /// let terrain = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XYZ(5, 5, 105), XYZ(15, 5, 155),
    ///     XYZ(15, 15, 125), XYZ(5, 15, 115), XYZ(5, 5, 105)]))
    /// let symDiff: Geometry<XYZ>? = try flatRect.symmetricDifference(with: terrain)
    /// // Returns an XYZ result with Z values from terrain where applicable
    /// ```
    func symmetricDifference<D: CoordinateType>(
        with geometry: any GeometryConvertible<D>
    ) throws -> Geometry<XYZ>? where D: HasZ {
        return try nilIfTooFewPoints {
            try performBinaryTopologyOperation(GEOSSymDifference_r, geometry: geometry)
        }
    }
}

public extension GeometryConvertible where C: HasZ {
    /// Computes the symmetric difference between this geometry and another.
    ///
    /// See `GEOSSymDifference_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a5c11e43cddf600366cff2a9cab98c53d).
    ///
    /// - Parameter geometry: The geometry to compute symmetric difference with (any dimension).
    /// - Returns: The symmetric difference as a ``Geometry`` with XYZ coordinates, or `nil` if the result is empty or
    ///   has too few points.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// // XYZ geometry symmetric difference with XY geometry returns XYZ
    /// let terrain = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XYZ(0, 0, 100), XYZ(10, 0, 150),
    ///     XYZ(10, 10, 120), XYZ(0, 10, 110), XYZ(0, 0, 100)]))
    /// let flatRect = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XY(5, 5), XY(15, 5), XY(15, 15), XY(5, 15), XY(5, 5)]))
    /// let symDiff = try terrain.symmetricDifference(with: flatRect)
    /// // Returns the non-overlapping regions, with Z values preserved
    /// ```
    func symmetricDifference<D: CoordinateType>(
        with geometry: any GeometryConvertible<D>
    ) throws -> Geometry<XYZ>? {
        return try nilIfTooFewPoints {
            try performBinaryTopologyOperation(GEOSSymDifference_r, geometry: geometry)
        }
    }
}
