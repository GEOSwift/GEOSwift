import Foundation
import geos

// MARK: - Clip Operations

// Clips geometries to a rectangular bounding box (envelope) using an optimized algorithm.
//
// This operation is faster than using general intersection with a rectangular polygon.
// Note: Not guaranteed to return valid results in all cases.
//
// ## Z Coordinate Preservation
//
// The dimension of the result depends on the dimension of the input geometry:
// - If the input has Z coordinates, the result will have Z coordinates
// - If the input has no Z coordinates, the result will be XY only
// - M coordinates are never preserved in the result
//
// Examples:
// - XY geometries → XY clipped geometry
// - XYZ geometries → XYZ clipped geometry
// - XYM geometries → XY clipped geometry (M is dropped)
// - XYZM geometries → XYZ clipped geometry (M is dropped)

public extension GeometryConvertible {
    private func _clip<D: CoordinateType>(by envelope: Envelope) throws -> Geometry<D>? {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)

        guard let resultPointer = GEOSClipByRect_r(
            context.handle,
            geosObject.pointer,
            envelope.minX,
            envelope.minY,
            envelope.maxX,
            envelope.maxY
        ) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }

        return try nilIfTooFewPoints {
            try Geometry(geosObject: GEOSObject(context: context, pointer: resultPointer))
        }
    }

    /// Clips the geometry to a rectangular bounding box.
    ///
    /// This operation uses an optimized algorithm for rectangular clipping that is faster than
    /// using general intersection. The result may not be valid in all cases.
    ///
    /// See `GEOSClipByRect_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a6e5efd34016d94bf5dfe73301e10162f).
    ///
    /// - Parameter envelope: The rectangular bounding box to clip to.
    /// - Returns: A clipped ``Geometry``, or `nil` if the result has too few points to form a
    ///   valid geometry.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let polygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XY(0, 0), XY(10, 0), XY(10, 10), XY(0, 10), XY(0, 0)
    /// ]))
    /// let envelope = Envelope(minX: 2, maxX: 8, minY: 2, maxY: 8)
    /// let clipped = try polygon.clip(by: envelope)
    /// // Returns the portion of the polygon within the envelope
    /// ```
    func clip(by envelope: Envelope) throws -> Geometry<XY>? {
        return try _clip(by: envelope)
    }
}

public extension GeometryConvertible where C: HasZ {
    /// Clips the geometry to a rectangular bounding box.
    ///
    /// This operation uses an optimized algorithm for rectangular clipping that is faster than
    /// using general intersection. The result may not be valid in all cases.
    ///
    /// See `GEOSClipByRect_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a6e5efd34016d94bf5dfe73301e10162f).
    ///
    /// - Parameter envelope: The rectangular bounding box to clip to.
    /// - Returns: A clipped ``Geometry`` with XYZ coordinates, or `nil` if the result has too few
    ///   points to form a valid geometry.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let polygon = try! Polygon(exterior: Polygon.LinearRing(coordinates: [
    ///     XYZ(0, 0, 10), XYZ(10, 0, 20), XYZ(10, 10, 30), XYZ(0, 10, 40), XYZ(0, 0, 10)
    /// ]))
    /// let envelope = Envelope(minX: 2, maxX: 8, minY: 2, maxY: 8)
    /// let clipped = try polygon.clip(by: envelope)
    /// // Returns the portion of the polygon within the envelope, preserving Z coordinates
    /// ```
    func clip(by envelope: Envelope) throws -> Geometry<XYZ>? {
        return try _clip(by: envelope)
    }
}
