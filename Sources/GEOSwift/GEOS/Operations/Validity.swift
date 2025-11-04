import Foundation
import geos

// MARK: - Input/Output types

/// The result of a detailed validity check on a geometry.
///
/// This enum provides detailed information about why a geometry is invalid,
/// including both a human-readable reason and the location of the invalidity.
public enum IsValidDetailResult<C: CoordinateType>: Hashable, Sendable {
    /// The geometry is valid according to OGC standards.
    case valid

    /// The geometry is invalid.
    ///
    /// - Parameters:
    ///   - reason: A human-readable description of why the geometry is invalid, or `nil` if unavailable.
    ///   - location: The geometric location where the invalidity occurs, or `nil` if unavailable.
    case invalid(reason: String?, location: Geometry<C>?)
}

/// Methods for making an invalid geometry valid.
///
/// Different methods may produce different results for the same input geometry.
/// The choice of method depends on your specific requirements for handling invalid geometries.
public enum MakeValidMethod {
    /// The linework method builds valid geometries by creating nodes at intersection points
    /// and forming the result from the linework created.
    ///
    /// This method is suitable for creating valid linear networks or polygon boundaries.
    case linework

    /// The structure method attempts to preserve the structure of the input geometry
    /// while making it valid.
    ///
    /// - Parameter keepCollapsed: If `true`, collapsed geometries (e.g., a polygon collapsed
    ///   to a line) are kept in the output. If `false`, collapsed geometries are removed.
    ///
    /// This method is more conservative and tries to maintain the original topology.
    case structure(keepCollapsed: Bool)

    var geosMethod: GEOSMakeValidMethods {
        switch self {
        case .linework:
            return GEOS_MAKE_VALID_LINEWORK
        case .structure:
            return GEOS_MAKE_VALID_STRUCTURE
        }
    }

    var keepCollapsed: Int32? {
        switch self {
        case .linework:
            return nil
        case .structure(let keepCollapsed):
            return keepCollapsed ? 1 : 0
        }
    }
}

// MARK: - Validity operations
//
// Tests and repairs geometries according to OGC validity rules. The dimension of the result
// matches the input (XY or XYZ). M coordinates are never preserved.

public extension GeometryConvertible {

    // MARK: IsValid

    /// Tests whether this geometry is valid according to OGC standards.
    ///
    /// Valid geometries have no self-intersections, appropriate boundary configurations,
    /// and satisfy all geometric constraints for their type.
    ///
    /// See `GEOSisValid_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#af7cddd14945d927c2006dd464cdfb8ee).
    ///
    /// - Returns: `true` if the geometry is valid, `false` otherwise.
    /// - Throws: `Error` if the validity check fails.
    ///
    /// ## Example
    /// ```swift
    /// let validPolygon = try Polygon(exterior: ...)
    /// try validPolygon.isValid() // true
    ///
    /// let invalidPolygon = try Polygon(exterior: /* self-intersecting ring */)
    /// try invalidPolygon.isValid() // false
    /// ```
    func isValid() throws -> Bool {
        try evaluateUnaryPredicate(GEOSisValid_r)
    }

    /// Returns a human-readable description of why this geometry is invalid.
    ///
    /// If the geometry is valid, returns "Valid Geometry".
    /// If invalid, returns a description of the invalidity (e.g., "Self-intersection", "Ring Self-intersection").
    ///
    /// See `GEOSisValidReason_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#abe6f16f64044decdba2fc051e53cd794).
    ///
    /// - Returns: A string describing the validity status or reason for invalidity.
    /// - Throws: `Error` if the validity check fails.
    ///
    /// ## Example
    /// ```swift
    /// let geometry = try Polygon(exterior: ...)
    /// let reason = try geometry.isValidReason()
    /// print(reason) // "Valid Geometry" or "Ring Self-intersection"
    /// ```
    func isValidReason() throws -> String {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)

        guard let cString = GEOSisValidReason_r(context.handle, geosObject.pointer) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        defer { GEOSFree_r(context.handle, cString) }

        return String(cString: cString)
    }

    /// Returns detailed information about the validity of this geometry.
    ///
    /// This method provides more information than `isValid()` by including both
    /// a human-readable reason for invalidity and the geometric location where
    /// the invalidity occurs.
    ///
    /// See `GEOSisValidDetail_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a52cb42712c5426e2df05aab5a281e23b).
    ///
    /// - Parameter allowSelfTouchingRingFormingHole: If `true`, allows polygon rings
    ///   to touch themselves to form holes (valid in some contexts). Default is `false`.
    /// - Returns: An ``IsValidDetailResult`` indicating validity status and details.
    /// - Throws: `Error` if the validity check fails.
    ///
    /// ## Example
    /// ```swift
    /// let geometry = try Polygon(exterior: ...)
    /// let result = try geometry.isValidDetail()
    ///
    /// switch result {
    /// case .valid:
    ///     print("Geometry is valid")
    /// case .invalid(let reason, let location):
    ///     print("Invalid: \(reason ?? "unknown")")
    ///     if let loc = location {
    ///         print("Problem at: \(loc)")
    ///     }
    /// }
    /// ```
    func isValidDetail(allowSelfTouchingRingFormingHole: Bool = false) throws -> IsValidDetailResult<C> {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let flags: Int32 = allowSelfTouchingRingFormingHole
            ? Int32(GEOSVALID_ALLOW_SELFTOUCHING_RING_FORMING_HOLE.rawValue)
            : 0
        var optionalReason: UnsafeMutablePointer<Int8>?
        var optionalLocation: OpaquePointer?

        switch GEOSisValidDetail_r(
            context.handle, geosObject.pointer, flags, &optionalReason, &optionalLocation) {
        case 1: // Valid
            if let reason = optionalReason {
                GEOSFree_r(context.handle, reason)
            }
            if let location = optionalLocation {
                GEOSGeom_destroy_r(context.handle, location)
            }
            return .valid
        case 0: // Invalid
            let reason = optionalReason.map { (reason) -> String in
                defer { GEOSFree_r(context.handle, reason) }
                return String(cString: reason)
            }
            let location = try optionalLocation.map { (location) -> Geometry<C> in
                let locationGEOSObject = GEOSObject(context: context, pointer: location)
                return try Geometry(geosObject: locationGEOSObject)
            }
            return .invalid(reason: reason, location: location)
        default: // Error
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
    }

    // MARK: MakeValid

    /// Attempts to make this geometry valid by applying GEOS repair algorithms.
    ///
    /// This method returns a new valid geometry based on the input. The output may be
    /// a different geometry type than the input. For example, a self-intersecting polygon
    /// might become a multi-polygon.
    ///
    /// See `GEOSMakeValid_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a869b4ed7b652a753a6135db88dbfbd72).
    ///
    /// - Returns: A valid ``Geometry``.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let invalidGeometry = try Polygon(exterior: /* self-intersecting ring */)
    /// let validGeometry = try invalidGeometry.makeValid()
    /// // Returns a geometry that might be a MultiPolygon with two valid polygons
    /// ```
    ///
    /// - Note: For more control over the validation algorithm, use `makeValid(method:)`.
    func makeValid() throws -> Geometry<XY> {
        try performUnaryTopologyOperation(GEOSMakeValid_r)
    }

    /// Attempts to make this geometry valid by applying GEOS repair algorithms.
    ///
    /// This method returns a new valid geometry based on the input. The output may be
    /// a different geometry type than the input.
    ///
    /// See `GEOSMakeValid_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a869b4ed7b652a753a6135db88dbfbd72).
    ///
    /// - Returns: A valid ``Geometry`` with XYZ coordinates.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let invalidGeometry = try Polygon(exterior: /* self-intersecting ring with Z values */)
    /// let validGeometry = try invalidGeometry.makeValid()
    /// // Returns a geometry with Z coordinates preserved
    /// ```
    ///
    /// - Note: For more control over the validation algorithm, use `makeValid(method:)`.
    func makeValid() throws -> Geometry<XYZ> where C: HasZ {
        try performUnaryTopologyOperation(GEOSMakeValid_r)
    }

    private func _makeValid<D: CoordinateType>(method: MakeValidMethod) throws -> Geometry<D> {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)
        let params = MakeValidParams(context: context, method: method)

        guard let pointer = GEOSMakeValidWithParams_r(
            context.handle,
            geosObject.pointer,
            params.pointer
        ) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }

        return try Geometry(geosObject: GEOSObject(context: context, pointer: pointer))
    }

    /// Attempts to make this geometry valid using a specific validation method.
    ///
    /// This method provides more control over the validation algorithm compared to `makeValid()`.
    /// Different methods may produce different results for the same invalid input.
    ///
    /// See `GEOSMakeValidWithParams_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a792e6527195c9e07b9ad94306f8cb9ca).
    ///
    /// - Parameter method: The ``MakeValidMethod`` to use.
    /// - Returns: A valid ``Geometry``.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let invalidGeometry = try Polygon(exterior: /* self-intersecting ring */)
    ///
    /// // Use linework method
    /// let result1 = try invalidGeometry.makeValid(method: .linework)
    ///
    /// // Use structure method, keeping collapsed geometries
    /// let result2 = try invalidGeometry.makeValid(method: .structure(keepCollapsed: true))
    ///
    /// // Use structure method, removing collapsed geometries
    /// let result3 = try invalidGeometry.makeValid(method: .structure(keepCollapsed: false))
    /// ```
    ///
    /// - SeeAlso: ``MakeValidMethod`` for details on available methods.
    func makeValid(method: MakeValidMethod) throws -> Geometry<XY> {
        return try _makeValid(method: method)
    }

    /// Attempts to make this geometry valid using a specific validation method.
    ///
    /// This method provides more control over the validation algorithm compared to `makeValid()`.
    /// Different methods may produce different results for the same invalid input.
    ///
    /// See `GEOSMakeValidWithParams_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html#a792e6527195c9e07b9ad94306f8cb9ca).
    ///
    /// - Parameter method: The ``MakeValidMethod`` to use.
    /// - Returns: A valid ``Geometry`` with XYZ coordinates.
    /// - Throws: `Error` if the operation fails.
    ///
    /// ## Example
    /// ```swift
    /// let invalidGeometry = try Polygon(exterior: /* self-intersecting ring with Z values */)
    ///
    /// // Use linework method
    /// let result1 = try invalidGeometry.makeValid(method: .linework)
    ///
    /// // Use structure method, keeping collapsed geometries
    /// let result2 = try invalidGeometry.makeValid(method: .structure(keepCollapsed: true))
    /// ```
    ///
    /// - SeeAlso: ``MakeValidMethod`` for details on available methods.
    func makeValid(method: MakeValidMethod) throws -> Geometry<XYZ> where C: HasZ {
        return try _makeValid(method: method)
    }
}

// MARK: - Internal Helpers

private class MakeValidParams {
    let context: GEOSContext
    let pointer: OpaquePointer

    init(context: GEOSContext, method: MakeValidMethod) {
        self.context = context
        self.pointer = GEOSMakeValidParams_create_r(context.handle)
        assert(GEOSMakeValidParams_setMethod_r(context.handle, pointer, method.geosMethod) == 1)
        if let keepCollapsed = method.keepCollapsed {
            assert(GEOSMakeValidParams_setKeepCollapsed_r(context.handle, pointer, keepCollapsed) == 1)
        }
    }

    deinit {
        GEOSMakeValidParams_destroy_r(context.handle, pointer)
    }
}
