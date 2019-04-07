import Foundation
import geos

public protocol WKTInitializable {
    init(wkt: String) throws
}

protocol WKTInitializableInternal: WKTInitializable, GEOSObjectInitializable {}

extension WKTInitializableInternal {
    public init(wkt: String) throws {
        let context = try GEOSContext()
        let reader = try WKTReader(context: context)
        try self.init(geosObject: try reader.read(wkt))
    }
}

extension Point: WKTInitializable, WKTInitializableInternal {}
extension LineString: WKTInitializable, WKTInitializableInternal {}
extension Polygon.LinearRing: WKTInitializable, WKTInitializableInternal {}
extension Polygon: WKTInitializable, WKTInitializableInternal {}
extension MultiPoint: WKTInitializable, WKTInitializableInternal {}
extension MultiLineString: WKTInitializable, WKTInitializableInternal {}
extension MultiPolygon: WKTInitializable, WKTInitializableInternal {}
extension GeometryCollection: WKTInitializable, WKTInitializableInternal {}
extension Geometry: WKTInitializable, WKTInitializableInternal {}

private final class WKTReader {
    private let context: GEOSContext
    private let reader: OpaquePointer

    init(context: GEOSContext) throws {
        guard let reader = GEOSWKTReader_create_r(context.handle) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        self.context = context
        self.reader = reader
    }

    deinit {
        GEOSWKTReader_destroy_r(context.handle, reader)
    }

    func read(_ wkt: String) throws -> GEOSObject {
        guard let geometryPointer = wkt.withCString({
            GEOSWKTReader_read_r(context.handle, reader, $0) }) else {
                throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return GEOSObject(context: context, pointer: geometryPointer)
    }
}
