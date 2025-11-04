import Foundation
import geos

// MARK: - Binary Predicate Operations

// Binary predicates test spatial relationships between two geometries. These operations return
// boolean values indicating whether a specific topological relationship holds between the geometries.

public extension GeometryConvertible {
    private typealias BinaryPredicate = (GEOSContextHandle_t, OpaquePointer, OpaquePointer) -> Int8

    private func evaluateBinaryPredicate<D: CoordinateType>(
        _ predicate: BinaryPredicate,
        with geometry: any GeometryConvertible<D>
    ) throws -> Bool {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let otherGeosObject = try geometry.geometry.geosObject(with: context)

        // returns 2 on exception, 1 on true, 0 on false
        let result = predicate(context.handle, geosObject.pointer, otherGeosObject.pointer)
        guard result != 2 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }

        return result == 1
    }

    /// Tests whether two geometries are topologically equal.
    ///
    /// Two geometries are considered topologically equal if they have the same structure and
    /// coordinates, regardless of the order of coordinates or sub-geometries.
    ///
    /// See `GEOSEquals_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a9530550693b82de827c5bf495bfdc9d7).
    ///
    /// - Parameter geometry: The geometry to test against.
    /// - Returns: `true` if the geometries are topologically equal, `false` otherwise.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let point1 = try! Point(x: 0, y: 0)
    /// let point2 = try! Point(x: 0, y: 0)
    /// let isEqual = try point1.isTopologicallyEquivalent(to: point2)
    /// // Returns true
    /// ```
    func isTopologicallyEquivalent<D: CoordinateType>(to geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSEquals_r, with: geometry)
    }

    /// Tests whether two geometries are spatially disjoint.
    ///
    /// Two geometries are disjoint if they have no points in common, meaning their interiors and
    /// boundaries do not intersect.
    ///
    /// See `GEOSDisjoint_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a9c34b47e7b8ee1236042638b0b8eaa0a).
    ///
    /// - Parameter geometry: The geometry to test against.
    /// - Returns: `true` if the geometries are disjoint, `false` otherwise.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let point1 = try! Point(x: 0, y: 0)
    /// let point2 = try! Point(x: 10, y: 10)
    /// let disjoint = try point1.isDisjoint(with: point2)
    /// // Returns true
    /// ```
    func isDisjoint<D: CoordinateType>(with geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSDisjoint_r, with: geometry)
    }

    /// Tests whether two geometries touch at their boundaries.
    ///
    /// Two geometries touch if they have at least one boundary point in common, but no interior
    /// points in common.
    ///
    /// See `GEOSTouches_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#aa362c11679646ce004758e224597405f).
    ///
    /// - Parameter geometry: The geometry to test against.
    /// - Returns: `true` if the geometries touch, `false` otherwise.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let line1 = try! LineString(coordinates: [XY(0, 0), XY(1, 1)])
    /// let line2 = try! LineString(coordinates: [XY(1, 1), XY(2, 2)])
    /// let touching = try line1.touches(line2)
    /// // Returns true (they share an endpoint)
    /// ```
    func touches<D: CoordinateType>(_ geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSTouches_r, with: geometry)
    }

    /// Tests whether two geometries intersect.
    ///
    /// Two geometries intersect if they have any points in common, including boundary or interior
    /// points. This is the opposite of ``isDisjoint(with:)``.
    ///
    /// See `GEOSIntersects_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a88f1dad8bdb2725c68de5fb7a3bcfd19).
    ///
    /// - Parameter geometry: The geometry to test against.
    /// - Returns: `true` if the geometries intersect, `false` otherwise.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let line1 = try! LineString(coordinates: [XY(0, 0), XY(2, 2)])
    /// let line2 = try! LineString(coordinates: [XY(0, 2), XY(2, 0)])
    /// let intersecting = try line1.intersects(line2)
    /// // Returns true (they cross at (1, 1))
    /// ```
    func intersects<D: CoordinateType>(_ geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSIntersects_r, with: geometry)
    }

    /// Tests whether two geometries cross each other.
    ///
    /// Two geometries cross if they have some, but not all, interior points in common and the
    /// dimension of the intersection is less than the maximum dimension of the two geometries.
    ///
    /// See `GEOSCrosses_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a4473ac0781c637d9fa923fcd3f2b7ad8).
    ///
    /// - Parameter geometry: The geometry to test against.
    /// - Returns: `true` if the geometries cross, `false` otherwise.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let line = try! LineString(coordinates: [XY(0, 0), XY(2, 2)])
    /// let polygon = try! Polygon(exteriorRing: LinearRing(coordinates:
    ///     [XY(1, 0), XY(3, 0), XY(3, 2), XY(1, 2), XY(1, 0)]))
    /// let crossing = try line.crosses(polygon)
    /// // Returns true (line passes through polygon)
    /// ```
    func crosses<D: CoordinateType>(_ geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSCrosses_r, with: geometry)
    }

    /// Tests whether this geometry is completely within another geometry.
    ///
    /// A geometry is within another if all of its points lie within the interior or on the
    /// boundary of the other geometry. This is the inverse of ``contains(_:)``.
    ///
    /// See `GEOSWithin_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#ac0ee4581f9cf772b4f064e70f14bd4a5).
    ///
    /// - Parameter geometry: The geometry to test against.
    /// - Returns: `true` if this geometry is within the other geometry, `false` otherwise.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let point = try! Point(x: 1, y: 1)
    /// let polygon = try! Polygon(exteriorRing: LinearRing(coordinates:
    ///     [XY(0, 0), XY(2, 0), XY(2, 2), XY(0, 2), XY(0, 0)]))
    /// let within = try point.isWithin(polygon)
    /// // Returns true
    /// ```
    func isWithin<D: CoordinateType>(_ geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSWithin_r, with: geometry)
    }

    /// Tests whether this geometry completely contains another geometry.
    ///
    /// A geometry contains another if all points of the other geometry lie within its interior
    /// or on its boundary. This is the inverse of ``isWithin(_:)``.
    ///
    /// See `GEOSContains_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a2d70c380adcacc52f9b377589cb9496a).
    ///
    /// - Parameter geometry: The geometry to test against.
    /// - Returns: `true` if this geometry contains the other geometry, `false` otherwise.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let polygon = try! Polygon(exteriorRing: LinearRing(coordinates:
    ///     [XY(0, 0), XY(2, 0), XY(2, 2), XY(0, 2), XY(0, 0)]))
    /// let point = try! Point(x: 1, y: 1)
    /// let containing = try polygon.contains(point)
    /// // Returns true
    /// ```
    func contains<D: CoordinateType>(_ geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSContains_r, with: geometry)
    }

    /// Tests whether two geometries overlap.
    ///
    /// Two geometries overlap if they have the same dimension, share some but not all points,
    /// and the intersection has the same dimension as the geometries themselves.
    ///
    /// See `GEOSOverlaps_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a9722bcbeaeb683742b3f73ff27ac14cb).
    ///
    /// - Parameter geometry: The geometry to test against.
    /// - Returns: `true` if the geometries overlap, `false` otherwise.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let polygon1 = try! Polygon(exteriorRing: LinearRing(coordinates:
    ///     [XY(0, 0), XY(2, 0), XY(2, 2), XY(0, 2), XY(0, 0)]))
    /// let polygon2 = try! Polygon(exteriorRing: LinearRing(coordinates:
    ///     [XY(1, 1), XY(3, 1), XY(3, 3), XY(1, 3), XY(1, 1)]))
    /// let overlapping = try polygon1.overlaps(polygon2)
    /// // Returns true
    /// ```
    func overlaps<D: CoordinateType>(_ geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSOverlaps_r, with: geometry)
    }

    /// Tests whether this geometry covers another geometry.
    ///
    /// A geometry covers another if every point of the other geometry is a point of this
    /// geometry. This is similar to ``contains(_:)`` but also returns `true` when the geometries
    /// are equal.
    ///
    /// See `GEOSCovers_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a95fc28c9031657e09047dc764b227377).
    ///
    /// - Parameter geometry: The geometry to test against.
    /// - Returns: `true` if this geometry covers the other geometry, `false` otherwise.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let polygon = try! Polygon(exteriorRing: LinearRing(coordinates:
    ///     [XY(0, 0), XY(2, 0), XY(2, 2), XY(0, 2), XY(0, 0)]))
    /// let line = try! LineString(coordinates: [XY(0, 0), XY(1, 1)])
    /// let covering = try polygon.covers(line)
    /// // Returns true
    /// ```
    func covers<D: CoordinateType>(_ geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSCovers_r, with: geometry)
    }

    /// Tests whether this geometry is covered by another geometry.
    ///
    /// A geometry is covered by another if every point of this geometry is a point of the other
    /// geometry. This is the inverse of ``covers(_:)``.
    ///
    /// See `GEOSCoveredBy_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a367fe922cb57431190ad7155bba0e8bd).
    ///
    /// - Parameter geometry: The geometry to test against.
    /// - Returns: `true` if this geometry is covered by the other geometry, `false` otherwise.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let line = try! LineString(coordinates: [XY(0, 0), XY(1, 1)])
    /// let polygon = try! Polygon(exteriorRing: LinearRing(coordinates:
    ///     [XY(0, 0), XY(2, 0), XY(2, 2), XY(0, 2), XY(0, 0)]))
    /// let covered = try line.isCovered(by: polygon)
    /// // Returns true
    /// ```
    func isCovered<D: CoordinateType>(by geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSCoveredBy_r, with: geometry)
    }
}
