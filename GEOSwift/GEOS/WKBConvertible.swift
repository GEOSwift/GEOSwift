import Foundation
import geos

public protocol WKBConvertible {
    func wkb() throws -> Data
}

protocol WKBConvertibleInternal: WKBConvertible, GEOSObjectConvertible {}

extension WKBConvertibleInternal {
    public func wkb() throws -> Data {
        let context = try GEOSContext()
        let writer = try WKBWriter(context: context)
        return try writer.write(self)
    }
}

extension Point: WKBConvertible, WKBConvertibleInternal {}
extension LineString: WKBConvertible, WKBConvertibleInternal {}
extension Polygon.LinearRing: WKBConvertible, WKBConvertibleInternal {}
extension Polygon: WKBConvertible, WKBConvertibleInternal {}
extension MultiPoint: WKBConvertible, WKBConvertibleInternal {}
extension MultiLineString: WKBConvertible, WKBConvertibleInternal {}
extension MultiPolygon: WKBConvertible, WKBConvertibleInternal {}
extension GeometryCollection: WKBConvertible, WKBConvertibleInternal {}
extension Geometry: WKBConvertible, WKBConvertibleInternal {}

private final class WKBWriter {
    private let context: GEOSContext
    private let writer: OpaquePointer

    init(context: GEOSContext) throws {
        guard let writer = GEOSWKBWriter_create_r(context.handle) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        self.context = context
        self.writer = writer
    }

    deinit {
        GEOSWKBWriter_destroy_r(context.handle, writer)
    }

    func write(_ geometry: GEOSObjectConvertible) throws -> Data {
        let geosObject = try geometry.geosObject(with: context)
        var bufferCount = 0
        guard let bufferPointer = GEOSWKBWriter_write_r(
            context.handle, writer, geosObject.pointer, &bufferCount) else {
                throw GEOSError.libraryError(errorMessages: context.errors)
        }
        defer { bufferPointer.deallocate() }
        return Data(buffer: UnsafeBufferPointer(start: bufferPointer, count: bufferCount))
    }
}
