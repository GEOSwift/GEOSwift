import Foundation
import geos

public protocol WKBInitializable {
    init(wkb: Data) throws
}

protocol WKBInitializableInternal: WKBInitializable, GEOSObjectInitializable {}

extension WKBInitializableInternal {
    public init(wkb: Data) throws {
        let context = try GEOSContext()
        let reader = try WKBReader(context: context)
        try self.init(geosObject: try reader.read(wkb))
    }
}

extension Point: WKBInitializable, WKBInitializableInternal {}
extension LineString: WKBInitializable, WKBInitializableInternal {}
// Polygon.LinearRing is omitted since it's not representable in WKB
extension Polygon: WKBInitializable, WKBInitializableInternal {}
extension MultiPoint: WKBInitializable, WKBInitializableInternal {}
extension MultiLineString: WKBInitializable, WKBInitializableInternal {}
extension MultiPolygon: WKBInitializable, WKBInitializableInternal {}
extension GeometryCollection: WKBInitializable, WKBInitializableInternal {}
extension Geometry: WKBInitializable, WKBInitializableInternal {}

private final class WKBReader {
    private let context: GEOSContext
    private let reader: OpaquePointer

    init(context: GEOSContext) throws {
        guard let reader = GEOSWKBReader_create_r(context.handle) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        self.context = context
        self.reader = reader
    }

    deinit {
        GEOSWKBReader_destroy_r(context.handle, reader)
    }

    func read(_ wkb: Data) throws -> GEOSObject {
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
}
