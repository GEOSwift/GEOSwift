import geos

/// A prepared geometry optimized for repeated spatial operations.
///
/// Prepared geometries build internal spatial indexes to speed up repeated operations
/// against the same base geometry.
///
/// - Important: Unlike most of GEOSwift, this type is **not thread safe**.
///
/// See the [GEOS Prepared Geometry API](https://libgeos.org/doxygen/geos__c_8h.html).
public final class PreparedGeometry<C: CoordinateType> {
    let context: GEOSContext
    private let base: GEOSObject
    let pointer: OpaquePointer

    init(context: GEOSContext, base: GEOSObject) throws {
        self.context = context
        self.base = base
        
        guard let pointer = GEOSPrepare_r(context.handle, base.pointer) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        self.pointer = pointer
    }

    deinit {
        GEOSPreparedGeom_destroy_r(context.handle, pointer)
    }

    /// Tests whether this geometry contains the specified geometry.
    ///
    /// See `GEOSPreparedContains_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html).
    ///
    /// - Parameter geometry: The geometry to test for containment.
    /// - Returns: `true` if this geometry contains the specified geometry, `false` otherwise.
    /// - Throws: `Error` if the containment test fails.
    public func contains(_ geometry: any GeometryConvertible<C>) throws -> Bool {
        let geosObject = try geometry.geometry.geosObject(with: context)
        
        // returns 1 on true, 0 on false, 2 on exception
        let result = GEOSPreparedContains_r(context.handle, pointer, geosObject.pointer)
        guard result != 2 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        
        return result == 1
    }

    /// Tests whether this geometry properly contains the specified geometry.
    ///
    /// See `GEOSPreparedContainsProperly_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html).
    ///
    /// - Parameter geometry: The geometry to test for proper containment.
    /// - Returns: `true` if this geometry properly contains the specified geometry, `false` otherwise.
    /// - Throws: `Error` if the containment test fails.
    public func containsProperly(_ geometry: any GeometryConvertible<C>) throws -> Bool {
        let geosObject = try geometry.geometry.geosObject(with: context)
        
        // returns 1 on true, 0 on false, 2 on exception
        let result = GEOSPreparedContainsProperly_r(context.handle, pointer, geosObject.pointer)
        guard result != 2 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        
        return result == 1
    }
}
