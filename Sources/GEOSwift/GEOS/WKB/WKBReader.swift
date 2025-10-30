import Foundation
import geos

public final class WKBReader {
    private let context: GEOSContext
    private let reader: OpaquePointer

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

    public func readAny(wkb: Data) throws -> AnyGeometry {
        return try AnyGeometry(geosObject: read(wkb))
    }
}
