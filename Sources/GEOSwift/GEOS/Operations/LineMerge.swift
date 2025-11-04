import Foundation
import geos

// MARK: - Line Merge Operations

// Merges LineStrings by joining them at nodes which have cardinality 2.
//
// ## Z Coordinate Preservation
//
// The dimension of the result depends on the dimension of the input geometry:
// - If the input has Z coordinates, the result will have Z coordinates
// - If the input has no Z coordinates, the result will be XY only
// - M coordinates are never preserved in the result
//
// Examples:
// - XY geometries → XY LineString or MultiLineString
// - XYZ geometries → XYZ LineString or MultiLineString
// - XYM geometries → XY LineString or MultiLineString (M is dropped)
// - XYZM geometries → XYZ LineString or MultiLineString (M is dropped)

public extension GeometryConvertible {
    private func _lineMerge<D: CoordinateType>() throws -> Geometry<D> {
        try performUnaryTopologyOperation(GEOSLineMerge_r)
    }

    /// Merges LineStrings by joining them at nodes which have cardinality 2.
    ///
    /// Lines may have their direction reversed during the merge process.
    ///
    /// See `GEOSLineMerge_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#af9a3b201bdef426ebdc93f64b0dc9f99).
    ///
    /// - Returns: A ``Geometry`` containing merged LineStrings (LineString or MultiLineString).
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let multiLineString = try! MultiLineString(lineStrings: [
    ///     LineString(coordinates: [XY(0, 0), XY(1, 0)]),
    ///     LineString(coordinates: [XY(1, 0), XY(0, 1)])])
    /// let result = try multiLineString.lineMerge()
    /// // Returns a LineString with merged segments: [(0,0), (1,0), (0,1)]
    /// ```
    func lineMerge() throws -> Geometry<XY> {
        return try _lineMerge()
    }

    private func _lineMergeDirected<D: CoordinateType>() throws -> Geometry<D> {
        try performUnaryTopologyOperation(GEOSLineMergeDirected_r)
    }

    /// Merges LineStrings by joining them at nodes which have cardinality 2 where lines have
    /// the same direction.
    ///
    /// Lines do not have their direction reversed during the merge process.
    ///
    /// See `GEOSLineMergeDirected_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a4abb8a3e436650244a683f6a2aea1782).
    ///
    /// - Returns: A ``Geometry`` containing merged LineStrings (LineString or MultiLineString).
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let multiLineString = try! MultiLineString(lineStrings: [
    ///     LineString(coordinates: [XY(0, 0), XY(1, 0)]),
    ///     LineString(coordinates: [XY(1, 0), XY(0, 1)])])
    /// let result = try multiLineString.lineMergeDirected()
    /// // Returns a LineString with merged segments: [(0,0), (1,0), (0,1)]
    /// ```
    func lineMergeDirected() throws -> Geometry<XY> {
        return try _lineMergeDirected()
    }
}

public extension GeometryConvertible where C: HasZ {
    /// Merges LineStrings by joining them at nodes which have cardinality 2.
    ///
    /// Lines may have their direction reversed during the merge process.
    ///
    /// See `GEOSLineMerge_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#af9a3b201bdef426ebdc93f64b0dc9f99).
    ///
    /// - Returns: A ``Geometry`` containing merged XYZ LineStrings (LineString or MultiLineString).
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let multiLineString = try! MultiLineString(lineStrings: [
    ///     LineString(coordinates: [XYZ(0, 0, 10), XYZ(1, 0, 20)]),
    ///     LineString(coordinates: [XYZ(1, 0, 20), XYZ(0, 1, 30)])])
    /// let result = try multiLineString.lineMerge()
    /// // Returns a LineString with merged segments preserving Z: [(0,0,10), (1,0,20), (0,1,30)]
    /// ```
    func lineMerge() throws -> Geometry<XYZ> {
        return try _lineMerge()
    }

    /// Merges LineStrings by joining them at nodes which have cardinality 2 where lines have
    /// the same direction.
    ///
    /// Lines do not have their direction reversed during the merge process.
    ///
    /// See `GEOSLineMergeDirected_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a4abb8a3e436650244a683f6a2aea1782).
    ///
    /// - Returns: A ``Geometry`` containing merged XYZ LineStrings (LineString or MultiLineString).
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let multiLineString = try! MultiLineString(lineStrings: [
    ///     LineString(coordinates: [XYZ(0, 0, 10), XYZ(1, 0, 20)]),
    ///     LineString(coordinates: [XYZ(1, 0, 20), XYZ(0, 1, 30)])])
    /// let result = try multiLineString.lineMergeDirected()
    /// // Returns a LineString with merged segments preserving Z: [(0,0,10), (1,0,20), (0,1,30)]
    /// ```
    func lineMergeDirected() throws -> Geometry<XYZ> {
        return try _lineMergeDirected()
    }
}
