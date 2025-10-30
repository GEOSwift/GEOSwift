import Foundation
import geos

public final class WKTReader {
    private let context: GEOSContext
    private let reader: OpaquePointer

    public convenience init() throws {
        try self.init(context: GEOSContext())
    }

    internal init(context: GEOSContext) throws {
        guard let reader = GEOSWKTReader_create_r(context.handle) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }

        self.context = context
        self.reader = reader
    }

    deinit {
        GEOSWKTReader_destroy_r(context.handle, reader)
    }

    internal func read(_ wkt: String) throws -> GEOSObject {
        guard let geometryPointer = wkt.withCString({
            GEOSWKTReader_read_r(context.handle, reader, $0) }) else {
                throw GEOSError.libraryError(errorMessages: context.errors)
        }

        return GEOSObject(context: context, pointer: geometryPointer)
    }

    public func readAny(wkt: String) throws -> AnyGeometry {
        return try AnyGeometry(geosObject: read(wkt))
    }
}
