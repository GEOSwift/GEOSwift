import Foundation
import geos

// MARK: - Intersection Operations

// Intersection operations for geometric objects.
//
// The intersection operation computes the set-theoretic intersection of two geometries,
// returning a new geometry representing all points that are common to both input geometries.
//
// ## Dimension Union Strategy
//
// These intersection operations follow a "dimension union" strategy for coordinate preservation:
// the result geometry's coordinate type is the union of the input coordinate types' dimensions.
// For example:
// - XY ∩ XY → XY
// - XY ∩ XYZ → XYZ (Z values interpolated from the XYZ geometry)
// - XYZ ∩ XYM → XYZM (Z interpolated from first, M set to NaN for new points)
// - XYZM ∩ XY → XYZM (Z and M interpolated from the XYZM geometry)
//
// This strategy ensures that coordinate dimensions are preserved whenever possible. Z values are
// interpolated along the intersection geometry based on the input geometries' coordinate values.
// M values are set to NaN where new intersection points are created.
//
// ## Notes
//
// - The operation may return `nil` if the result is empty.
// - Self-intersections within input geometries are handled according to OGC standards.
// - The result's geometry type depends on the intersection of the inputs (e.g., two polygons may
//   intersect as a polygon, line, or point).

extension GeometryConvertible {
    fileprivate func _intersection<D: CoordinateType, E: CoordinateType>(
        with geometry: any GeometryConvertible<D>
    ) throws -> Geometry<E>? {
        return try nilIfTooFewPoints {
            try performBinaryTopologyOperation(GEOSIntersection_r, geometry: geometry)
        }
    }
}

// MARK: - XY Intersection Operations

public extension GeometryConvertible where C == XY {
    /// Computes the intersection of this XY geometry with another XY geometry.
    ///
    /// - Parameter geometry: The geometry to intersect with.
    /// - Returns: The intersection as an XY geometry, or `nil` if the result is empty.
    /// - Throws: An error if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let poly1 = try Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XY(0, 0), XY(2, 0), XY(2, 2), XY(0, 2), XY(0, 0)]))
    /// let poly2 = try Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XY(1, 1), XY(3, 1), XY(3, 3), XY(1, 3), XY(1, 1)]))
    /// let result = try poly1.intersection(with: poly2) // Overlapping square
    /// ```
    func intersection(with geometry: any GeometryConvertible<XY>) throws -> Geometry<XY>? {
        return try _intersection(with: geometry)
    }

    /// Computes the intersection of this XY geometry with an XYZ geometry, preserving Z coordinates.
    ///
    /// The result will be an XYZ geometry with Z values interpolated from the XYZ input geometry.
    ///
    /// - Parameter geometry: The XYZ geometry to intersect with.
    /// - Returns: The intersection as an XYZ geometry, or `nil` if the result is empty.
    /// - Throws: An error if the operation fails.
    func intersection(with geometry: any GeometryConvertible<XYZ>) throws -> Geometry<XYZ>? {
        return try _intersection(with: geometry)
    }

    /// Computes the intersection of this XY geometry with an XYM geometry, preserving M coordinates.
    ///
    /// The result will be an XYM geometry. M values are set to NaN where new intersection points are created.
    ///
    /// - Parameter geometry: The XYM geometry to intersect with.
    /// - Returns: The intersection as an XYM geometry, or `nil` if the result is empty.
    /// - Throws: An error if the operation fails.
    func intersection(with geometry: any GeometryConvertible<XYM>) throws -> Geometry<XYM>? {
        return try _intersection(with: geometry)
    }

    /// Computes the intersection of this XY geometry with an XYZM geometry, preserving both Z and M coordinates.
    ///
    /// The result will be an XYZM geometry with Z values interpolated from the XYZM input geometry.
    /// M values are set to NaN where new intersection points are created.
    ///
    /// - Parameter geometry: The XYZM geometry to intersect with.
    /// - Returns: The intersection as an XYZM geometry, or `nil` if the result is empty.
    /// - Throws: An error if the operation fails.
    func intersection(with geometry: any GeometryConvertible<XYZM>) throws -> Geometry<XYZM>? {
        return try _intersection(with: geometry)
    }
}

// MARK: - XYZ Intersection Operations

public extension GeometryConvertible where C == XYZ {
    /// Computes the intersection of this XYZ geometry with any geometry, preserving Z coordinates.
    ///
    /// The result will be an XYZ geometry with Z values interpolated from this XYZ geometry.
    /// If the other geometry has Z coordinates, both sets of Z values are used for interpolation.
    ///
    /// - Parameter geometry: The geometry to intersect with (can be XY, XYZ, XYM, or XYZM).
    /// - Returns: The intersection as an XYZ geometry, or `nil` if the result is empty.
    /// - Throws: An error if the operation fails.
    ///
    /// ## Examples
    /// ```swift
    /// let line3D = try LineString(coordinates: [XYZ(0, 0, 10), XYZ(2, 2, 20)])
    /// let poly2D = try Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XY(0, 0), XY(2, 0), XY(2, 2), XY(0, 2), XY(0, 0)]))
    /// let result = try line3D.intersection(with: poly2D) // XYZ result with interpolated Z
    /// ```
    func intersection<D: CoordinateType>(with geometry: any GeometryConvertible<D>) throws -> Geometry<XYZ>? {
        return try _intersection(with: geometry)
    }

    /// Computes the intersection of this XYZ geometry with a geometry that has M coordinates,
    /// preserving both Z and M coordinates.
    ///
    /// The result will be an XYZM geometry with Z values interpolated from this XYZ geometry.
    /// M values are set to NaN where new intersection points are created.
    ///
    /// - Parameter geometry: A geometry with M coordinates (XYM or XYZM) to intersect with.
    /// - Returns: The intersection as an XYZM geometry, or `nil` if the result is empty.
    /// - Throws: An error if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let line3D = try LineString(coordinates: [XYZ(0, 0, 10), XYZ(2, 2, 20)])
    /// let lineM = try LineString(coordinates: [XYM(0, 2, 100), XYM(2, 0, 200)])
    /// let result = try line3D.intersection(with: lineM) // XYZM result with both dimensions
    /// ```
    func intersection<D: CoordinateType>(
        with geometry: any GeometryConvertible<D>
    ) throws -> Geometry<XYZM>? where D: HasM {
        return try _intersection(with: geometry)
    }
}

// MARK: - XYM Intersection Operations

public extension GeometryConvertible where C == XYM {
    /// Computes the intersection of this XYM geometry with any geometry, preserving M coordinates.
    ///
    /// The result will be an XYM geometry. M values are set to NaN where new intersection points are created.
    ///
    /// - Parameter geometry: The geometry to intersect with (can be XY, XYZ, XYM, or XYZM).
    /// - Returns: The intersection as an XYM geometry, or `nil` if the result is empty.
    /// - Throws: An error if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let route = try LineString(coordinates: [XYM(0, 0, 0), XYM(10, 10, 100)])
    /// let area = try Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XY(5, 0), XY(15, 0), XY(15, 10), XY(5, 10), XY(5, 0)]))
    /// let result = try route.intersection(with: area) // XYM result with M values
    /// ```
    func intersection<D: CoordinateType>(with geometry: any GeometryConvertible<D>) throws -> Geometry<XYM>? {
        return try _intersection(with: geometry)
    }

    /// Computes the intersection of this XYM geometry with a geometry that has Z coordinates,
    /// preserving both M and Z coordinates.
    ///
    /// The result will be an XYZM geometry with Z values interpolated from the other geometry.
    /// M values are set to NaN where new intersection points are created.
    ///
    /// - Parameter geometry: A geometry with Z coordinates (XYZ or XYZM) to intersect with.
    /// - Returns: The intersection as an XYZM geometry, or `nil` if the result is empty.
    /// - Throws: An error if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let route = try LineString(coordinates: [XYM(0, 0, 0), XYM(10, 10, 100)])
    /// let terrain = try LineString(coordinates: [XYZ(0, 10, 500), XYZ(10, 0, 300)])
    /// let result = try route.intersection(with: terrain) // XYZM with elevation and measures
    /// ```
    func intersection<D: CoordinateType>(
        with geometry: any GeometryConvertible<D>
    ) throws -> Geometry<XYZM>? where D: HasZ {
        return try _intersection(with: geometry)
    }
}

// MARK: - XYZM Intersection Operations

public extension GeometryConvertible where C == XYZM {
    /// Computes the intersection of this XYZM geometry with any geometry, preserving all coordinates.
    ///
    /// The result will always be an XYZM geometry with Z values interpolated from this XYZM geometry.
    /// If the other geometry also has Z coordinates, both sets of Z values are used for interpolation.
    /// M values are set to NaN where new intersection points are created.
    ///
    /// - Parameter geometry: The geometry to intersect with (can be XY, XYZ, XYM, or XYZM).
    /// - Returns: The intersection as an XYZM geometry, or `nil` if the result is empty.
    /// - Throws: An error if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let route3D = try LineString(coordinates: [
    ///     XYZM(0, 0, 100, 0), XYZM(10, 10, 200, 1000)])
    /// let boundary = try Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XY(5, 0), XY(15, 0), XY(15, 10), XY(5, 10), XY(5, 0)]))
    /// let result = try route3D.intersection(with: boundary) // XYZM with all dimensions
    /// ```
    func intersection<D: CoordinateType>(with geometry: any GeometryConvertible<D>) throws -> Geometry<XYZM>? {
        return try _intersection(with: geometry)
    }
}
