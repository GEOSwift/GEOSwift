import Foundation
import geos

// MARK: - DE-9IM Relate Operations

// Provides operations for computing the Dimensionally Extended 9-Intersection Model (DE-9IM) relationship
// between geometries. DE-9IM describes the topological relationship between two geometries by analyzing
// the intersections of their interior, boundary, and exterior.

public extension GeometryConvertible {
    /// Tests whether the relationship between two geometries matches a DE-9IM pattern.
    ///
    /// See `GEOSRelatePattern_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a106fdf636b50f98ac26a8a856aa2cab3).
    ///
    /// - Parameter geometry: The geometry to test the relationship with.
    /// - Parameter mask: The DE-9IM pattern to match against. A 9-character string containing symbols in
    ///   the set "012TF*". "012F" match the corresponding dimension symbol; "T" matches any non-empty
    ///   dimension; "*" matches any dimension.
    /// - Returns: `true` if the computed DE-9IM matrix matches the pattern, `false` otherwise.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let polygon = try! Polygon(exterior: LinearRing(coordinates: [
    ///     XY(0, 0), XY(2, 0), XY(2, 2), XY(0, 2), XY(0, 0)]))
    /// let point = try! Point(coordinate: XY(1, 1))
    /// let contains = try polygon.relate(point, mask: "T*F**F***")
    /// // Returns true, indicating the point is within the polygon
    /// ```
    func relate<D: CoordinateType>(_ geometry: any GeometryConvertible<D>, mask: String) throws -> Bool {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let otherGeosObject = try geometry.geometry.geosObject(with: context)

        // returns 2 on exception, 1 on true, 0 on false
        let result = mask.withCString {
            GEOSRelatePattern_r(context.handle, geosObject.pointer, otherGeosObject.pointer, $0)
        }
        guard result != 2 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }

        return result == 1
    }

    /// Computes the DE-9IM relationship matrix between two geometries.
    ///
    /// See `GEOSRelate_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#ab5fae8697125d74079570141a4c3f5dc).
    ///
    /// - Parameter geometry: The geometry to compute the relationship with.
    /// - Returns: A 9-character string representing the DE-9IM matrix, containing dimension symbols
    ///   in the set "012F". The characters represent the dimensionality of the intersections between
    ///   the interior, boundary, and exterior of each geometry.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let line1 = try! LineString(coordinates: [XY(0, 0), XY(2, 2)])
    /// let line2 = try! LineString(coordinates: [XY(0, 2), XY(2, 0)])
    /// let matrix = try line1.relate(line2)
    /// // Returns a string like "0F1FF0102", describing the topological relationship
    /// ```
    func relate<D: CoordinateType>(_ geometry: any GeometryConvertible<D>) throws -> String {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let otherGeosObject = try geometry.geometry.geosObject(with: context)

        guard let cString = GEOSRelate_r(context.handle, geosObject.pointer, otherGeosObject.pointer) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        defer { GEOSFree_r(context.handle, cString) }

        return String(cString: cString)
    }
}
