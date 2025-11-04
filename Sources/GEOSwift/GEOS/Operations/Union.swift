import Foundation
import geos

// MARK: - Union Operations

// Computes the set-theoretic union of two geometries.
//
// ## Dimension Union Strategy
//
// These union operations follow a "dimension union" strategy for coordinate preservation:
// the result geometry's coordinate type is the union of the input coordinate types' dimensions.
// For example:
// - XY ∪ XY → XY
// - XY ∪ XYZ → XYZ (Z values interpolated from the XYZ geometry)
// - XYZ ∪ XYM → XYZM (Z interpolated from first, M set to NaN for new points)
// - XYZM ∪ XY → XYZM (Z interpolated from first, M set to NaN for new points)
//
// This strategy ensures that coordinate dimensions are preserved whenever possible. Z values are
// interpolated along the union geometry based on the input geometries' coordinate values.
// M values are set to NaN where new union points are created.
//
// ## Notes
//
// - The operation may return `nil` if the result is empty.
// - Self-intersections within input geometries are handled according to OGC standards.
// - The result's geometry type depends on the union of the inputs (e.g., two polygons may
//   union as a polygon or multi-polygon).

extension GeometryConvertible {
    fileprivate func _union<D: CoordinateType, E: CoordinateType>(
        with geometry: any GeometryConvertible<D>
    ) throws -> Geometry<E>? {
        try performBinaryTopologyOperation(GEOSUnion_r, geometry: geometry)
    }
}

// MARK: - XY Union Operations

public extension GeometryConvertible where C == XY {
    /// Computes the union of this XY geometry with another XY geometry.
    ///
    /// See `GEOSUnion_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a5689cad561ddd4528a1c5522d0de0543).
    ///
    /// - Parameter geometry: The geometry to union with.
    /// - Returns: The union as a ``Geometry``, or `nil` if the result is empty.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let poly1 = try Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XY(0, 0), XY(1, 0), XY(1, 1), XY(0, 1), XY(0, 0)]))
    /// let poly2 = try Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XY(1, 0), XY(2, 0), XY(2, 1), XY(1, 1), XY(1, 0)]))
    /// let result = try poly1.union(with: poly2) // Combined rectangle
    /// ```
    func union(with geometry: any GeometryConvertible<XY>) throws -> Geometry<XY>? {
        return try _union(with: geometry)
    }

    /// Computes the union of this XY geometry with an XYZ geometry, preserving Z coordinates.
    ///
    /// The result will be an XYZ geometry with Z values interpolated from the XYZ input geometry.
    ///
    /// See `GEOSUnion_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a5689cad561ddd4528a1c5522d0de0543).
    ///
    /// - Parameter geometry: The XYZ geometry to union with.
    /// - Returns: The union as a ``Geometry`` with XYZ coordinates, or `nil` if the result is empty.
    /// - Throws: `Error` if the operation fails.
    func union(with geometry: any GeometryConvertible<XYZ>) throws -> Geometry<XYZ>? {
        return try _union(with: geometry)
    }

    /// Computes the union of this XY geometry with an XYM geometry, preserving M coordinates.
    ///
    /// The result will be an XYM geometry. M values are set to NaN where new union points are created.
    ///
    /// See `GEOSUnion_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a5689cad561ddd4528a1c5522d0de0543).
    ///
    /// - Parameter geometry: The XYM geometry to union with.
    /// - Returns: The union as a ``Geometry`` with XYM coordinates, or `nil` if the result is empty.
    /// - Throws: `Error` if the operation fails.
    func union(with geometry: any GeometryConvertible<XYM>) throws -> Geometry<XYM>? {
        return try _union(with: geometry)
    }

    /// Computes the union of this XY geometry with an XYZM geometry, preserving both Z and M coordinates.
    ///
    /// The result will be an XYZM geometry with Z values interpolated from the XYZM input geometry.
    /// M values are set to NaN where new union points are created.
    ///
    /// See `GEOSUnion_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a5689cad561ddd4528a1c5522d0de0543).
    ///
    /// - Parameter geometry: The XYZM geometry to union with.
    /// - Returns: The union as a ``Geometry`` with XYZM coordinates, or `nil` if the result is empty.
    /// - Throws: `Error` if the operation fails.
    func union(with geometry: any GeometryConvertible<XYZM>) throws -> Geometry<XYZM>? {
        return try _union(with: geometry)
    }
}

// MARK: - XYZ Union Operations

public extension GeometryConvertible where C == XYZ {
    /// Computes the union of this XYZ geometry with any geometry, preserving Z coordinates.
    ///
    /// The result will be an XYZ geometry with Z values interpolated from this XYZ geometry.
    /// If the other geometry has Z coordinates, both sets of Z values are used for interpolation.
    ///
    /// See `GEOSUnion_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a5689cad561ddd4528a1c5522d0de0543).
    ///
    /// - Parameter geometry: The geometry to union with (can be XY, XYZ, XYM, or XYZM).
    /// - Returns: The union as a ``Geometry`` with XYZ coordinates, or `nil` if the result is empty.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let line3D = try LineString(coordinates: [XYZ(0, 0, 10), XYZ(2, 0, 20)])
    /// let poly2D = try Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XY(1, 0), XY(3, 0), XY(3, 2), XY(1, 2), XY(1, 0)]))
    /// let result = try line3D.union(with: poly2D) // XYZ result with interpolated Z
    /// ```
    func union<D: CoordinateType>(with geometry: any GeometryConvertible<D>) throws -> Geometry<XYZ>? {
        return try _union(with: geometry)
    }

    /// Computes the union of this XYZ geometry with a geometry that has M coordinates,
    /// preserving both Z and M coordinates.
    ///
    /// The result will be an XYZM geometry with Z values interpolated from this XYZ geometry.
    /// M values are set to NaN where new union points are created.
    ///
    /// See `GEOSUnion_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a5689cad561ddd4528a1c5522d0de0543).
    ///
    /// - Parameter geometry: A geometry with M coordinates (XYM or XYZM) to union with.
    /// - Returns: The union as a ``Geometry`` with XYZM coordinates, or `nil` if the result is empty.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let line3D = try LineString(coordinates: [XYZ(0, 0, 10), XYZ(2, 0, 20)])
    /// let lineM = try LineString(coordinates: [XYM(1, 0, 100), XYM(3, 0, 200)])
    /// let result = try line3D.union(with: lineM) // XYZM result with both dimensions
    /// ```
    func union<D: CoordinateType>(
        with geometry: any GeometryConvertible<D>
    ) throws -> Geometry<XYZM>? where D: HasM {
        return try _union(with: geometry)
    }
}

// MARK: - XYM Union Operations

public extension GeometryConvertible where C == XYM {
    /// Computes the union of this XYM geometry with any geometry, preserving M coordinates.
    ///
    /// The result will be an XYM geometry. M values are set to NaN where new union points are created.
    ///
    /// See `GEOSUnion_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a5689cad561ddd4528a1c5522d0de0543).
    ///
    /// - Parameter geometry: The geometry to union with (can be XY, XYZ, XYM, or XYZM).
    /// - Returns: The union as a ``Geometry`` with XYM coordinates, or `nil` if the result is empty.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let route = try LineString(coordinates: [XYM(0, 0, 0), XYM(10, 0, 100)])
    /// let area = try Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XY(5, 0), XY(15, 0), XY(15, 10), XY(5, 10), XY(5, 0)]))
    /// let result = try route.union(with: area) // XYM result with M values
    /// ```
    func union<D: CoordinateType>(with geometry: any GeometryConvertible<D>) throws -> Geometry<XYM>? {
        return try _union(with: geometry)
    }

    /// Computes the union of this XYM geometry with a geometry that has Z coordinates,
    /// preserving both M and Z coordinates.
    ///
    /// The result will be an XYZM geometry with Z values interpolated from the other geometry.
    /// M values are set to NaN where new union points are created.
    ///
    /// See `GEOSUnion_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a5689cad561ddd4528a1c5522d0de0543).
    ///
    /// - Parameter geometry: A geometry with Z coordinates (XYZ or XYZM) to union with.
    /// - Returns: The union as a ``Geometry`` with XYZM coordinates, or `nil` if the result is empty.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let route = try LineString(coordinates: [XYM(0, 0, 0), XYM(10, 0, 100)])
    /// let terrain = try LineString(coordinates: [XYZ(5, 0, 500), XYZ(15, 0, 300)])
    /// let result = try route.union(with: terrain) // XYZM with elevation and measures
    /// ```
    func union<D: CoordinateType>(
        with geometry: any GeometryConvertible<D>
    ) throws -> Geometry<XYZM>? where D: HasZ {
        return try _union(with: geometry)
    }
}

// MARK: - XYZM Union Operations

public extension GeometryConvertible where C == XYZM {
    /// Computes the union of this XYZM geometry with any geometry, preserving all coordinates.
    ///
    /// The result will always be an XYZM geometry with Z values interpolated from this XYZM geometry.
    /// If the other geometry also has Z coordinates, both sets of Z values are used for interpolation.
    /// M values are set to NaN where new union points are created.
    ///
    /// See `GEOSUnion_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a5689cad561ddd4528a1c5522d0de0543).
    ///
    /// - Parameter geometry: The geometry to union with (can be XY, XYZ, XYM, or XYZM).
    /// - Returns: The union as a ``Geometry`` with XYZM coordinates, or `nil` if the result is empty.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let route3D = try LineString(coordinates: [
    ///     XYZM(0, 0, 100, 0), XYZM(10, 0, 200, 1000)])
    /// let boundary = try Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XY(5, 0), XY(15, 0), XY(15, 10), XY(5, 10), XY(5, 0)]))
    /// let result = try route3D.union(with: boundary) // XYZM with all dimensions
    /// ```
    func union<D: CoordinateType>(with geometry: any GeometryConvertible<D>) throws -> Geometry<XYZM>? {
        return try _union(with: geometry)
    }
}
