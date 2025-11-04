import Foundation
import geos

// MARK: - Unary Predicate Operations
//
// Tests and predicates that operate on a single geometry to determine specific geometric properties.

public extension GeometryConvertible {
    internal typealias UnaryPredicate = (GEOSContextHandle_t, OpaquePointer) -> Int8

    internal func evaluateUnaryPredicate(_ predicate: UnaryPredicate) throws -> Bool {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)

        // returns 2 on exception, 1 on true, 0 on false
        let result = predicate(context.handle, geosObject.pointer)
        guard result != 2 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }

        return result == 1
    }

    /// Tests whether this geometry is empty.
    ///
    /// A geometry is empty if it has no points. An empty geometry has no boundary or interior.
    /// If the geometry or any component is non-empty, the geometry is non-empty.
    ///
    /// See `GEOSisEmpty_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a01cb336a8127f0ab8e590728b029bbe6).
    ///
    /// - Returns: `true` if the geometry is empty, `false` otherwise.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let emptyPoint = Point<XY>()
    /// try emptyPoint.isEmpty() // true
    ///
    /// let point = Point(XY(1.0, 2.0))
    /// try point.isEmpty() // false
    ///
    /// let emptyLineString = LineString<XY>(coordinates: [])
    /// try emptyLineString.isEmpty() // true
    /// ```
    func isEmpty() throws -> Bool {
        try evaluateUnaryPredicate(GEOSisEmpty_r)
    }

    /// Tests whether this geometry is a ring.
    ///
    /// A ring is a linestring that is both closed (start and end points are identical) and simple
    /// (does not self-intersect). Rings are the fundamental component of polygon boundaries.
    ///
    /// See `GEOSisRing_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a069fc969f6c32e78c4b5a7aa2df8a2db).
    ///
    /// - Returns: `true` if the geometry is a valid ring, `false` otherwise.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// // A closed, simple linestring forms a ring
    /// let ring = try LineString(coordinates: [
    ///     XY(0, 0), XY(1, 0), XY(1, 1), XY(0, 1), XY(0, 0)])
    /// try ring.isRing() // true
    ///
    /// // Not closed (start != end)
    /// let notClosed = try LineString(coordinates: [
    ///     XY(0, 0), XY(1, 0), XY(1, 1)])
    /// try notClosed.isRing() // false
    ///
    /// // Self-intersecting (not simple)
    /// let selfIntersecting = try LineString(coordinates: [
    ///     XY(0, 0), XY(1, 1), XY(1, 0), XY(0, 1), XY(0, 0)])
    /// try selfIntersecting.isRing() // false
    /// ```
    func isRing() throws -> Bool {
        try evaluateUnaryPredicate(GEOSisRing_r)
    }
}
