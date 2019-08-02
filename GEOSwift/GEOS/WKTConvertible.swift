import Foundation
import geos

public protocol WKTConvertible {
    func wkt() throws -> String
}

protocol WKTConvertibleInternal: WKTConvertible, GEOSObjectConvertible {}

extension WKTConvertibleInternal {
    public func wkt() throws -> String {
        let context = try GEOSContext()
        let writer = try WKTWriter(context: context)
        return try writer.write(self)
    }
}

extension Point: WKTConvertible, WKTConvertibleInternal {}
extension LineString: WKTConvertible, WKTConvertibleInternal {}
extension Polygon.LinearRing: WKTConvertible, WKTConvertibleInternal {}
extension Polygon: WKTConvertible, WKTConvertibleInternal {}
extension MultiPoint: WKTConvertible, WKTConvertibleInternal {}
extension MultiLineString: WKTConvertible, WKTConvertibleInternal {}
extension MultiPolygon: WKTConvertible, WKTConvertibleInternal {}
extension GeometryCollection: WKTConvertible, WKTConvertibleInternal {}
extension Geometry: WKTConvertible, WKTConvertibleInternal {}

private final class WKTWriter {
    private let context: GEOSContext
    private let writer: OpaquePointer

    init(context: GEOSContext) throws {
        guard let writer = GEOSWKTWriter_create_r(context.handle) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        self.context = context
        self.writer = writer
    }

    deinit {
        GEOSWKTWriter_destroy_r(context.handle, writer)
    }

    func write(_ geometry: GEOSObjectConvertible) throws -> String {
        let geosObject = try geometry.geosObject(with: context)
        guard let chars = GEOSWKTWriter_write_r(context.handle, writer, geosObject.pointer) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        defer { chars.deallocate() }
        return String(cString: chars)
    }
}
