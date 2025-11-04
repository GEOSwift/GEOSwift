import Foundation
import geos

// MARK: - Binary Operations

// Operations that compute relationships and measurements between two geometries.

public extension GeometryConvertible {
    internal typealias BinaryOperation = (GEOSContextHandle_t, OpaquePointer, OpaquePointer) -> OpaquePointer?

    internal func performBinaryTopologyOperation<D: CoordinateType, E: CoordinateType>(
        _ operation: BinaryOperation,
        geometry: any GeometryConvertible<D>
    ) throws -> Geometry<E> {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let otherGeosObject = try geometry.geometry.geosObject(with: context)

        guard let pointer = operation(context.handle, geosObject.pointer, otherGeosObject.pointer) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }

        return try Geometry(geosObject: GEOSObject(context: context, pointer: pointer))
    }

    /// Computes the minimum distance between this geometry and another geometry.
    ///
    /// See `GEOSDistance_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a1eaffa44bf168e98cef8ecca7d08e77d).
    ///
    /// - Parameter to: The geometry to compute distance to.
    /// - Returns: The minimum distance between the two geometries.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let point1 = Point(XY(0, 0))
    /// let point2 = Point(XY(3, 4))
    /// let distance = try point1.distance(to: point2)
    /// // Returns 5.0
    /// ```
    func distance<D: CoordinateType>(to geometry: any GeometryConvertible<D>) throws -> Double {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let otherGeosObject = try geometry.geometry.geosObject(with: context)
        var dist: Double = 0

        // returns 0 on exception
        guard GEOSDistance_r(context.handle, geosObject.pointer, otherGeosObject.pointer, &dist) != 0 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }

        return dist
    }

    /// Computes the Hausdorff distance between this geometry and another geometry.
    ///
    /// The Hausdorff distance is the maximum distance between the geometries, measuring how far apart
    /// the most distant points are. It is often used to measure the similarity between geometries.
    ///
    /// See `GEOSHausdorffDistance_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#ae819e5d9990e99116e75d804bb8fc538).
    ///
    /// - Parameter to: The geometry to compute Hausdorff distance to.
    /// - Returns: The Hausdorff distance between the two geometries.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let line1 = try LineString(coordinates: [XY(0, 0), XY(1, 0)])
    /// let line2 = try LineString(coordinates: [XY(0, 1), XY(1, 1)])
    /// let distance = try line1.hausdorffDistance(to: line2)
    /// // Returns the maximum distance between any point on line1 and its nearest point on line2
    /// ```
    func hausdorffDistance<D: CoordinateType>(to geometry: any GeometryConvertible<D>) throws -> Double {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let otherGeosObject = try geometry.geometry.geosObject(with: context)

        var distance: Double = 0

        // returns 0 on exception
        guard GEOSHausdorffDistance_r(
            context.handle,
            geosObject.pointer,
            otherGeosObject.pointer,
            &distance
        ) == 1 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }

        return distance
    }

    /// Computes the Hausdorff distance with additional densification for improved accuracy.
    ///
    /// This variant of Hausdorff distance densifies the input geometries before computing the
    /// distance, which can provide more accurate results for curved or complex geometries.
    ///
    /// See `GEOSHausdorffDistanceDensify_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#afc24d8564b76ee8f6e43111142db753b).
    ///
    /// - Parameter to: The geometry to compute Hausdorff distance to.
    /// - Parameter densifyFraction: The fraction by which to densify each segment. A value of 0.5
    ///   will add a point at the midpoint of each segment. Must be between 0 and 1.
    /// - Returns: The densified Hausdorff distance between the two geometries.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let polygon1 = try Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XY(0, 0), XY(4, 0), XY(4, 4), XY(0, 4), XY(0, 0)]))
    /// let polygon2 = try Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XY(1, 1), XY(5, 1), XY(5, 5), XY(1, 5), XY(1, 1)]))
    /// let distance = try polygon1.hausdorffDistanceDensify(to: polygon2, densifyFraction: 0.5)
    /// // Returns more accurate Hausdorff distance with densified segments
    /// ```
    func hausdorffDistanceDensify<D: CoordinateType>(
        to geometry: any GeometryConvertible<D>,
        densifyFraction: Double
    ) throws -> Double {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let otherGeosObject = try geometry.geometry.geosObject(with: context)

        var distance: Double = 0

        // returns 0 on exception
        guard GEOSHausdorffDistanceDensify_r(
            context.handle,
            geosObject.pointer,
            otherGeosObject.pointer,
            densifyFraction,
            &distance
        ) == 1 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }

        return distance
    }

    /// Finds the two points on the geometries that are closest to each other.
    ///
    /// The first point in the returned array is on this geometry, and the second point is on the
    /// other geometry. The distance between these points is the minimum distance between the
    /// geometries. Note that this method always returns ``Point`` geometries with XY coordinates,
    /// regardless of the input geometry dimensions.
    ///
    /// See `GEOSNearestPoints_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a79a868afc65a7bd21632bfd5c7724461).
    ///
    /// - Parameter with: The geometry to find nearest points with.
    /// - Returns: An array of two ``Point`` geometries. The first point is on this geometry, and
    ///   the second is on the other geometry.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let line1 = try LineString(coordinates: [XY(0, 0), XY(2, 0)])
    /// let line2 = try LineString(coordinates: [XY(1, 2), XY(3, 2)])
    /// let points = try line1.nearestPoints(with: line2)
    /// // Returns [Point(XY(1, 0)), Point(XY(1, 2))]
    /// ```
    func nearestPoints<D: CoordinateType>(with geometry: any GeometryConvertible<D>) throws -> [Point<XY>] {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let otherGeosObject = try geometry.geometry.geosObject(with: context)

        guard let coordSeq = GEOSNearestPoints_r(
            context.handle, geosObject.pointer, otherGeosObject.pointer) else {
                throw GEOSError.libraryError(errorMessages: context.errors)
        }

        defer { GEOSCoordSeq_destroy_r(context.handle, coordSeq) }
        let point0 = try Point(coordinates: XY.bridge.getter(context, coordSeq, 0))
        let point1 = try Point(coordinates: XY.bridge.getter(context, coordSeq, 1))

        return [point0, point1]
    }
}
