import Foundation
import geos

/// A reader for parsing Well-Known Text (WKT) format.
///
/// See `GEOSWKTReader_read_r` in the
/// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html).
public final class WKTReader {
    private let context: GEOSContext
    private let reader: OpaquePointer

    /// Creates a new WKT reader.
    ///
    /// - Throws: `Error` if the reader cannot be created.
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

    /// Reads a geometry from Well-Known Text (WKT) format.
    ///
    /// See `GEOSWKTReader_read_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html).
    ///
    /// - Parameter wkt: The WKT string to parse.
    /// - Returns: The parsed geometry as ``AnyGeometry``.
    /// - Throws: `Error` if the WKT string is invalid or cannot be parsed.
    public func readAny(wkt: String) throws -> AnyGeometry {
        return try AnyGeometry(geosObject: read(wkt))
    }
}
