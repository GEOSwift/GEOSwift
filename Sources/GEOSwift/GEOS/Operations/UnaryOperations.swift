// MARK: - Unary Operations

/// Unary operations perform geometric computations on a single geometry, including measurements,
/// transformations, and derived geometric properties.

import Foundation
import geos

public extension GeometryConvertible {
    internal func nilIfTooFewPoints<D: CoordinateType>(op: () throws -> Geometry<D>) throws -> Geometry<D>? {
        do {
            return try op()
        } catch GEOSwiftError.tooFewCoordinates {
            return nil
        } catch {
            throw error
        }
    }

    internal typealias UnaryOperation = (GEOSContextHandle_t, OpaquePointer) -> OpaquePointer?

    internal func performUnaryTopologyOperation<T>(_ operation: UnaryOperation) throws -> T
        where T: GEOSObjectInitializable {
            let context = try GEOSContext()
            let geosObject = try geometry.geosObject(with: context)

            guard let pointer = operation(context.handle, geosObject.pointer) else {
                throw GEOSError.libraryError(errorMessages: context.errors)
            }

            return try T(geosObject: GEOSObject(context: context, pointer: pointer))
    }

    /// Computes the total length of a geometry.
    ///
    /// See `GEOSLength_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a9778c9b2bc37d8c6850c4c97c878e5f6).
    ///
    /// - Returns: The length of the geometry. For linear geometries, returns the total length of all
    ///   segments. For non-linear geometries, returns 0.
    /// - Throws: ``GEOSError`` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let line = LineString<XY>(coordinates: [Coordinate(x: 0, y: 0), Coordinate(x: 3, y: 4)])
    /// let length = try line.length() // 5.0
    /// ```
    func length() throws -> Double {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)
        var length: Double = 0

        // returns 0 on exception
        guard GEOSLength_r(context.handle, geosObject.pointer, &length) != 0 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }

        return length
    }

    /// Calculates the area enclosed by a geometry.
    ///
    /// See `GEOSArea_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#aa67b6c3d96f1b0ea0801b506a4c5d961).
    ///
    /// - Returns: The area of the geometry. For areal geometries (polygons), returns the total area.
    ///   For non-areal geometries, returns 0.
    /// - Throws: ``GEOSError`` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let polygon = Polygon<XY>(exterior: LinearRing(coordinates: [
    ///     Coordinate(x: 0, y: 0), Coordinate(x: 4, y: 0),
    ///     Coordinate(x: 4, y: 3), Coordinate(x: 0, y: 3), Coordinate(x: 0, y: 0)
    /// ]))
    /// let area = try polygon.area() // 12.0
    /// ```
    func area() throws -> Double {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)
        var area: Double = 0

        // returns 0 on exception
        guard GEOSArea_r(context.handle, geosObject.pointer, &area) != 0 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }

        return area
    }

    /// Returns the bounding rectangle of a geometry.
    ///
    /// See `GEOSEnvelope_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a69964db7ec98e8eace0ba91046ba5d04).
    ///
    /// - Returns: An ``Envelope`` representing the minimum bounding rectangle that contains the
    ///   geometry.
    /// - Throws: ``GEOSError`` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let line = LineString<XY>(coordinates: [
    ///     Coordinate(x: 1, y: 2), Coordinate(x: 5, y: 8)
    /// ])
    /// let env = try line.envelope() // Envelope(minX: 1, maxX: 5, minY: 2, maxY: 8)
    /// ```
    func envelope() throws -> Envelope {
        let geometry: Geometry<XY> = try performUnaryTopologyOperation(GEOSEnvelope_r)

        switch geometry {
        case let .point(point):
            return Envelope(
                minX: point.coordinates.x,
                maxX: point.coordinates.x,
                minY: point.coordinates.y,
                maxY: point.coordinates.y
            )
        case let .polygon(polygon):
            var minX = Double.nan
            var maxX = Double.nan
            var minY = Double.nan
            var maxY = Double.nan
            for coordinate in polygon.exterior.coordinates {
                minX = .minimum(minX, coordinate.x)
                maxX = .maximum(maxX, coordinate.x)
                minY = .minimum(minY, coordinate.y)
                maxY = .maximum(maxY, coordinate.y)
            }
            return Envelope(minX: minX, maxX: maxX, minY: minY, maxY: maxY)
        default:
            throw GEOSwiftError.unexpectedEnvelopeResult(AnyGeometry(geometry))
        }
    }

    /// Converts a geometry to normalized form for comparison.
    ///
    /// Normalization ensures that geometrically equivalent geometries have identical representations,
    /// making them suitable for comparison operations.
    ///
    /// See `GEOSNormalize_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#aaf4fdd418434d65c81265ff81c02b0a3).
    ///
    /// - Returns: A normalized ``Geometry`` with the same coordinate dimensions as the input.
    /// - Throws: ``GEOSError`` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let polygon = Polygon<XYZ>(exterior: LinearRing(coordinates: [...]))
    /// let normalized = try polygon.normalized() // Geometry<XYZ>
    /// ```
    func normalized() throws -> Geometry<C> {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)

        // GEOSNormalize_r returns -1 on exception
        guard GEOSNormalize_r(context.handle, geosObject.pointer) != -1 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }

        return try Geometry(geosObject: geosObject)
    }

    /// Computes the smallest rotated rectangular envelope containing a geometry.
    ///
    /// See `GEOSMinimumRotatedRectangle_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a07e1a37d27d4577e908815d8defd08a4).
    ///
    /// - Returns: A ``Geometry`` (typically a polygon) representing the minimum rotated rectangle.
    ///   Always returns XY coordinates, dropping any Z or M dimensions.
    /// - Throws: ``GEOSError`` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let points = MultiPoint<XY>(points: [
    ///     Point(x: 0, y: 0), Point(x: 3, y: 1), Point(x: 1, y: 4)
    /// ])
    /// let rect = try points.minimumRotatedRectangle() // Geometry<XY>
    /// ```
    func minimumRotatedRectangle() throws -> Geometry<XY> {
        try performUnaryTopologyOperation(GEOSMinimumRotatedRectangle_r)
    }

    /// Calculates the minimum width line segment across a geometry.
    ///
    /// See `GEOSMinimumWidth_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a76f00f6b7283c22ff054fb4d43f3b46a).
    ///
    /// - Returns: A ``LineString`` representing the minimum width of the geometry. Always returns XY
    ///   coordinates, dropping any Z or M dimensions.
    /// - Throws: ``GEOSError`` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let polygon = Polygon<XY>(exterior: LinearRing(coordinates: [...]))
    /// let width = try polygon.minimumWidth() // LineString<XY>
    /// ```
    func minimumWidth() throws -> LineString<XY> {
        try performUnaryTopologyOperation(GEOSMinimumWidth_r)
    }

    /// Unions all components of a single geometry together.
    ///
    /// See `GEOSUnaryUnion_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a28cbcc9f0d147686bde98ffc74bba39b).
    ///
    /// - Returns: A unified ``Geometry`` with the same coordinate dimensions as the input.
    /// - Throws: ``GEOSError`` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let multiPolygon = MultiPolygon<XYZ>(polygons: [poly1, poly2])
    /// let unified = try multiPolygon.unaryUnion() // Geometry<XYZ>
    /// ```
    func unaryUnion() throws -> Geometry<C> {
        try performUnaryTopologyOperation(GEOSUnaryUnion_r)
    }

    /// Finds a point guaranteed to lie on the geometry's surface.
    ///
    /// See `GEOSPointOnSurface_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#ac2920c143818c6491d6b409ac7abf06d).
    ///
    /// - Returns: A ``Point`` on the surface of the geometry. Always returns XY coordinates, dropping
    ///   any Z or M dimensions.
    /// - Throws: ``GEOSError`` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let polygon = Polygon<XY>(exterior: LinearRing(coordinates: [...]))
    /// let point = try polygon.pointOnSurface() // Point<XY>
    /// ```
    func pointOnSurface() throws -> Point<XY> {
        try performUnaryTopologyOperation(GEOSPointOnSurface_r)
    }

    /// Computes the centroid of a geometry.
    ///
    /// See `GEOSGetCentroid_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#abb7020993cdaf5e786655bd0495d87d8).
    ///
    /// - Returns: A ``Point`` at the centroid of the geometry. Always returns XY coordinates, dropping
    ///   any Z or M dimensions.
    /// - Throws: ``GEOSError`` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let polygon = Polygon<XY>(exterior: LinearRing(coordinates: [
    ///     Coordinate(x: 0, y: 0), Coordinate(x: 4, y: 0),
    ///     Coordinate(x: 4, y: 3), Coordinate(x: 0, y: 3), Coordinate(x: 0, y: 0)
    /// ]))
    /// let center = try polygon.centroid() // Point<XY>(x: 2, y: 1.5)
    /// ```
    func centroid() throws -> Point<XY> {
        try performUnaryTopologyOperation(GEOSGetCentroid_r)
    }

    /// Calculates the smallest circle containing a geometry.
    ///
    /// See `GEOSMinimumBoundingCircle_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#aa235d4583bbca73401b886730895e2c0).
    ///
    /// - Returns: A ``Circle`` representing the minimum bounding circle. Always returns XY
    ///   coordinates, dropping any Z or M dimensions.
    /// - Throws: ``GEOSError`` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let points = MultiPoint<XY>(points: [
    ///     Point(x: 0, y: 0), Point(x: 3, y: 0), Point(x: 0, y: 4)
    /// ])
    /// let circle = try points.minimumBoundingCircle() // Circle<XY>
    /// ```
    func minimumBoundingCircle() throws -> Circle<XY> {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)
        var radius: Double = 0
        var optionalCenterPointer: OpaquePointer?

        guard let geometryPointer = GEOSMinimumBoundingCircle_r(
            context.handle, geosObject.pointer, &radius, &optionalCenterPointer) else {
                // if we somehow end up with a non-null center and a null geometry,
                // we must still destroy the center before throwing an error
                if let centerPointer = optionalCenterPointer {
                    GEOSGeom_destroy_r(context.handle, centerPointer)
                }
                throw GEOSError.libraryError(errorMessages: context.errors)
        }

        // For our purposes, we only care about the center and radius.
        GEOSGeom_destroy_r(context.handle, geometryPointer)
        guard let centerPointer = optionalCenterPointer else {
            throw GEOSError.noMinimumBoundingCircle
        }

        let center = try Point<XY>(geosObject: GEOSObject(context: context, pointer: centerPointer))
        return Circle(center: center, radius: radius)
    }
}
