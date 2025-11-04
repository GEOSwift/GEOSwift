import Foundation
import geos

// MARK: - Polygonize Operations

// Creates polygons from linear edges by forming closed rings from the extracted linework.
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
    /// See `GEOSPolygonize_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#af9cb8c195ea3578dce68975b9395e7c6).
    ///
    /// - Returns: A ``GeometryCollection`` containing polygons formed from closed rings, or an empty collection.
    /// - Throws: `Error` if the operation fails.
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
    /// Polygonizes this geometry by extracting linework and forming polygons from closed rings.
    ///
    /// See `GEOSPolygonize_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#af9cb8c195ea3578dce68975b9395e7c6).
    ///
    /// - Returns: A ``GeometryCollection`` containing XYZ polygons formed from closed rings, or an empty collection.
    /// - Throws: `Error` if the operation fails.
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
    /// See `GEOSPolygonize_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#af9cb8c195ea3578dce68975b9395e7c6).
    ///
    /// - Returns: A ``GeometryCollection`` containing polygons formed from closed rings, or an empty collection.
    /// - Throws: `Error` if the operation fails.
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
    /// Polygonizes a collection of geometries by extracting linework and forming polygons from closed rings.
    ///
    /// See `GEOSPolygonize_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#af9cb8c195ea3578dce68975b9395e7c6).
    ///
    /// - Returns: A ``GeometryCollection`` containing XYZ polygons formed from closed rings, or an empty collection.
    /// - Throws: `Error` if the operation fails.
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
    func polygonize() throws -> GeometryCollection<XYZ> {
        return try _polygonize()
    }
}
