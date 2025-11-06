import Foundation
import geos

/// A reader for parsing Well-Known Binary (WKB) format.
///
/// See `GEOSWKBReader_read_r` in the
/// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html).
public final class WKBReader {
    private let context: GEOSContext
    private let reader: OpaquePointer

    /// Creates a new WKB reader.
    ///
    /// - Throws: `Error` if the reader cannot be created.
    public convenience init() throws {
        try self.init(context: GEOSContext())
    }

    internal init(context: GEOSContext) throws {
        guard let reader = GEOSWKBReader_create_r(context.handle) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }

        self.context = context
        self.reader = reader
    }

    deinit {
        GEOSWKBReader_destroy_r(context.handle, reader)
    }

    internal func read(_ wkb: Data) throws -> GEOSObject {
        let pointer = try wkb.withUnsafeBytes { (unsafeRawBufferPointer) -> OpaquePointer in
            guard let unsafePointer = unsafeRawBufferPointer.baseAddress?
                .bindMemory(to: UInt8.self, capacity: unsafeRawBufferPointer.count) else {
                    throw GEOSError.wkbDataWasEmpty
            }
            guard let pointer = GEOSWKBReader_read_r(
                context.handle, reader, unsafePointer, unsafeRawBufferPointer.count) else {
                    throw GEOSError.libraryError(errorMessages: context.errors)
            }
            return pointer
        }

        return GEOSObject(context: context, pointer: pointer)
    }

    /// Reads a geometry from Well-Known Binary (WKB) data.
    ///
    /// See `GEOSWKBReader_read_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html).
    ///
    /// - Parameter wkb: The WKB data to parse.
    /// - Returns: The parsed geometry as ``AnyGeometry``.
    /// - Throws: `Error` if the WKB data is invalid or cannot be parsed.
    public func readAny(wkb: Data) throws -> AnyGeometry {
        return try AnyGeometry(geosObject: read(wkb))
    }
}
