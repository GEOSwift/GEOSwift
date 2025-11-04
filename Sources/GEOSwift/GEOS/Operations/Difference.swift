import Foundation
import geos

// MARK: - Difference Operations

// Computes the set of points in one geometry that are not in another geometry.
//
// ## Z Coordinate Preservation
//
// The dimension of the result depends on the dimensions of both input geometries:
// - If EITHER operand has Z coordinates, the result will have Z coordinates
// - If NEITHER operand has Z coordinates, the result will be XY only
// - M coordinates are never preserved in the result
//
// Examples:
// - XY.difference(XY) → XY result
// - XY.difference(XYZ) → XYZ result (second operand has Z)
// - XYZ.difference(XY) → XYZ result (first operand has Z)
// - XYZ.difference(XYZ) → XYZ result (both have Z)
// - XYM.difference(XYM) → XY result (M is not preserved)
// - XYZM.difference(XY) → XYZ result (first has Z, M is dropped)
//
// For geometries with Z coordinates, Z values are taken from the corresponding
// vertices in the input geometries. When new vertices are created through intersection,
// Z values are interpolated.

public extension GeometryConvertible {
    /// Computes the difference between this geometry and another.
    ///
    /// See `GEOSDifference_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#ac4c13c9cdaa71b23a3c44a6d3f72c2c1).
    ///
    /// - Parameter geometry: The geometry to subtract from this geometry (any dimension).
    /// - Returns: The difference as a ``Geometry``, or `nil` if the result is empty or has too few points.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let rect1 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XY(0, 0), XY(2, 0), XY(2, 2), XY(0, 2), XY(0, 0)]))
    /// let rect2 = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XY(1, 1), XY(3, 1), XY(3, 3), XY(1, 3), XY(1, 1)]))
    /// let diff = try rect1.difference(with: rect2)
    /// // Returns the L-shaped region: rect1 minus the overlapping area
    /// ```
    func difference<D: CoordinateType>(with geometry: any GeometryConvertible<D>) throws -> Geometry<XY>? {
        return try nilIfTooFewPoints {
            try performBinaryTopologyOperation(GEOSDifference_r, geometry: geometry)
        }
    }

    /// Computes the difference between this geometry and another.
    ///
    /// See `GEOSDifference_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#ac4c13c9cdaa71b23a3c44a6d3f72c2c1).
    ///
    /// - Parameter geometry: The geometry with Z coordinates to subtract from this geometry.
    /// - Returns: The difference as a ``Geometry`` with XYZ coordinates, or `nil` if the result is empty or has
    ///   too few points.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// // XY geometry differenced with XYZ geometry returns XYZ
    /// let flatRect = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XY(0, 0), XY(10, 0), XY(10, 10), XY(0, 10), XY(0, 0)]))
    /// let terrain = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XYZ(5, 5, 105), XYZ(15, 5, 155),
    ///     XYZ(15, 15, 125), XYZ(5, 15, 115), XYZ(5, 5, 105)]))
    /// let diff: Geometry<XYZ>? = try flatRect.difference(with: terrain)
    /// // Returns an XYZ result with Z values from terrain where applicable
    /// ```
    func difference<D: CoordinateType>(
        with geometry: any GeometryConvertible<D>
    ) throws -> Geometry<XYZ>? where D: HasZ {
        return try nilIfTooFewPoints {
            try performBinaryTopologyOperation(GEOSDifference_r, geometry: geometry)
        }
    }
}

public extension GeometryConvertible where C: HasZ {
    /// Computes the difference between this geometry and another.
    ///
    /// See `GEOSDifference_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#ac4c13c9cdaa71b23a3c44a6d3f72c2c1).
    ///
    /// - Parameter geometry: The geometry to subtract from this geometry (any dimension).
    /// - Returns: The difference as a ``Geometry`` with XYZ coordinates, or `nil` if the result is empty or has
    ///   too few points.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// // XYZ geometry differenced with XY geometry returns XYZ
    /// let terrain = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XYZ(0, 0, 100), XYZ(10, 0, 150),
    ///     XYZ(10, 10, 120), XYZ(0, 10, 110), XYZ(0, 0, 100)]))
    /// let flatRect = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XY(5, 5), XY(15, 5), XY(15, 15), XY(5, 15), XY(5, 5)]))
    /// let diff = try terrain.difference(with: flatRect)
    /// // Returns terrain minus the overlapping area, with Z values preserved
    /// ```
    func difference<D: CoordinateType>(with geometry: any GeometryConvertible<D>) throws -> Geometry<XYZ>? {
        return try nilIfTooFewPoints {
            try performBinaryTopologyOperation(GEOSDifference_r, geometry: geometry)
        }
    }
}
