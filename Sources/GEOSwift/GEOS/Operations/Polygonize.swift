import Foundation
import geos

// MARK: - Polygonize Operations

// Polygonize operations for geometric objects.
//
// The polygonize operation creates a collection of polygons from the linear edges contained
// within input geometries. It accepts any geometry type and extracts the constituent linework
// to form polygon boundaries. This is commonly used to build polygon geometries from linear
// features representing boundaries, such as contour lines or administrative borders.
//
// ## How Polygonize Works
//
// The polygonize operation processes input geometries by:
// 1. Extracting all linear edges from the input (regardless of geometry type)
// 2. Identifying edges that connect to form closed rings
// 3. Creating polygons from these closed rings
// 4. Returns a GeometryCollection containing the resulting polygons
//
// ## Input Requirements
//
// - **Any geometry type is accepted**: Point, LineString, Polygon, Multi*, GeometryCollection
// - **Edges must be properly noded**: They should only meet at their endpoints, not overlap
// - **No self-intersections**: Edges should not cross themselves or each other except at nodes
//
// ## Return Types
//
// The polygonize operation always returns a GeometryCollection:
// - Returns an empty GeometryCollection if no closed rings can be formed
// - Returns a GeometryCollection containing one or more Polygons if successful
// - Improperly noded or self-intersecting edges may produce unexpected results
//
// ## Z Coordinate Preservation
//
// The dimension of the result depends on the dimension of the input geometry:
// - If the input has Z coordinates, the result will have Z coordinates
// - If the input has no Z coordinates, the result will be XY only
// - M coordinates are never preserved in the result
//
// Examples:
// - XY geometries → XY polygons in GeometryCollection
// - XYZ geometries → XYZ polygons in GeometryCollection
// - XYM geometries → XY polygons in GeometryCollection (M is dropped)
// - XYZM geometries → XYZ polygons in GeometryCollection (M is dropped)
//
// For geometries with Z coordinates, Z values are preserved from the extracted linework
// in the resulting polygon boundaries.
//
// ## Notes
//
// - Extracts linework from all geometry types, not just LineStrings
// - Partial or incomplete rings will not form polygons
// - The operation follows the OGC Simple Features specification

public extension GeometryConvertible {
    private func _polygonize<D: CoordinateType>() throws -> GeometryCollection<D> {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)
        let pointer = GEOSPolygonize_r(context.handle, [geosObject.pointer], 1)

        guard let pointer else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }

        return try GeometryCollection(geosObject: GEOSObject(context: context, pointer: pointer))
    }

    /// Polygonizes this geometry by extracting linework and forming polygons from closed rings.
    ///
    /// This method accepts any geometry type and extracts the constituent linear edges to create
    /// polygons. The edges must be properly noded (meeting only at endpoints) to form valid polygons.
    /// This overload is used when the geometry does not have Z coordinates.
    ///
    /// - Returns: A GeometryCollection containing polygons formed from closed rings, or an empty collection.
    /// - Throws: An error if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let multiLineString = try! MultiLineString(lineStrings: [
    ///     LineString(coordinates: [XY(0, 0), XY(1, 0)]),
    ///     LineString(coordinates: [XY(1, 0), XY(0, 1)]),
    ///     LineString(coordinates: [XY(0, 1), XY(0, 0)])])
    /// let result = try multiLineString.polygonize()
    /// // Returns a GeometryCollection with a triangle polygon
    /// ```
    func polygonize() throws -> GeometryCollection<XY> {
        return try _polygonize()
    }
}

public extension GeometryConvertible where C: HasZ {
    /// Polygonizes this geometry by extracting linework and forming polygons from closed rings,
    /// preserving Z coordinates.
    ///
    /// This method accepts any geometry type and extracts the constituent linear edges to create
    /// polygons. The edges must be properly noded (meeting only at endpoints) to form valid polygons.
    /// This overload is used when the geometry has Z coordinates (XYZ or XYZM), and the result
    /// will preserve Z coordinates in the output polygons.
    ///
    /// - Returns: A GeometryCollection containing XYZ polygons formed from closed rings, or an empty collection.
    /// - Throws: An error if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let multiLineString = try! MultiLineString(lineStrings: [
    ///     LineString(coordinates: [XYZ(0, 0, 10), XYZ(1, 0, 20)]),
    ///     LineString(coordinates: [XYZ(1, 0, 20), XYZ(0, 1, 30)]),
    ///     LineString(coordinates: [XYZ(0, 1, 30), XYZ(0, 0, 10)])])
    /// let result = try multiLineString.polygonize()
    /// // Returns a GeometryCollection with a triangle polygon preserving Z coordinates
    /// ```
    ///
    /// ## Notes
    /// - Available for geometries with Z coordinates (XYZ and XYZM).
    /// - For XYZM geometries, M coordinates are not preserved; only XYZ is returned.
    /// - Z values are preserved from the extracted linework in the polygon boundaries.
    func polygonize() throws -> GeometryCollection<XYZ> {
        return try _polygonize()
    }
}

public extension Collection where Element: GeometryConvertible {
    private func _polygonize<D: CoordinateType>() throws -> GeometryCollection<D> {
        let context = try GEOSContext()
        let geosObjects = try map { try $0.geometry.geosObject(with: context) }
        let pointer = withExtendedLifetime(geosObjects) { geosObjects in
            GEOSPolygonize_r(context.handle, geosObjects.map { $0.pointer }, UInt32(geosObjects.count))
        }

        guard let pointer else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }

        return try GeometryCollection(geosObject: GEOSObject(context: context, pointer: pointer))
    }

    /// Polygonizes a collection of geometries by extracting linework and forming polygons from closed rings.
    ///
    /// This method processes a collection of geometries (of any type) and extracts all linear edges
    /// to create polygons. The edges must be properly noded (meeting only at endpoints) to form valid
    /// polygons. This overload is used when the collection contains geometries without Z coordinates.
    ///
    /// - Returns: A GeometryCollection containing polygons formed from closed rings, or an empty collection.
    /// - Throws: An error if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let lineStrings = [
    ///     try! LineString(coordinates: [XY(0, 0), XY(1, 0)]),
    ///     try! LineString(coordinates: [XY(1, 0), XY(0, 1)]),
    ///     try! LineString(coordinates: [XY(0, 1), XY(0, 0)])]
    /// let result = try lineStrings.polygonize()
    /// // Returns a GeometryCollection with a triangle polygon
    /// ```
    func polygonize() throws -> GeometryCollection<XY> {
        return try _polygonize()
    }
}

public extension Collection where Element: GeometryConvertible, Element.C: HasZ {
    /// Polygonizes a collection of geometries by extracting linework and forming polygons from closed rings,
    /// preserving Z coordinates.
    ///
    /// This method processes a collection of geometries (of any type) and extracts all linear edges
    /// to create polygons. The edges must be properly noded (meeting only at endpoints) to form valid
    /// polygons. This overload is used when the collection contains geometries with Z coordinates (XYZ
    /// or XYZM), and the result will preserve Z coordinates in the output polygons.
    ///
    /// - Returns: A GeometryCollection containing XYZ polygons formed from closed rings, or an empty collection.
    /// - Throws: An error if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let lineStrings = [
    ///     try! LineString(coordinates: [XYZ(0, 0, 10), XYZ(1, 0, 20)]),
    ///     try! LineString(coordinates: [XYZ(1, 0, 20), XYZ(0, 1, 30)]),
    ///     try! LineString(coordinates: [XYZ(0, 1, 30), XYZ(0, 0, 10)])]
    /// let result = try lineStrings.polygonize()
    /// // Returns a GeometryCollection with a triangle polygon preserving Z coordinates
    /// ```
    ///
    /// ## Notes
    /// - Available for collections of geometries with Z coordinates (XYZ and XYZM).
    /// - For XYZM geometries, M coordinates are not preserved; only XYZ is returned.
    /// - Z values are preserved from the extracted linework in the polygon boundaries.
    func polygonize() throws -> GeometryCollection<XYZ> {
        return try _polygonize()
    }
}
