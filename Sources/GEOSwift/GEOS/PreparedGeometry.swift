import geos

/// A prepared geometry. Unlike most of GEOSwift, this type is not thread safe.
public final class PreparedGeometry {
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

    public func contains(_ geometry: GeometryConvertible) throws -> Bool {
        let geosObject = try geometry.geometry.geosObject(with: context)
        // returns 1 on true, 0 on false, 2 on exception
        let result = GEOSPreparedContains_r(context.handle, pointer, geosObject.pointer)
        guard result != 2 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return result == 1
    }

    public func containsProperly(_ geometry: GeometryConvertible) throws -> Bool {
        let geosObject = try geometry.geometry.geosObject(with: context)
        // returns 1 on true, 0 on false, 2 on exception
        let result = GEOSPreparedContainsProperly_r(context.handle, pointer, geosObject.pointer)
        guard result != 2 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return result == 1
    }
}
