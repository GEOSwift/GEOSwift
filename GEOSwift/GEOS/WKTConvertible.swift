import Foundation
import geos

public protocol WKTConvertible {
    func wkt() throws -> String

    func wkt(useFixedPrecision: Bool, roundingPrecision: Int32) throws -> String
}

protocol WKTConvertibleInternal: WKTConvertible, GEOSObjectConvertible {}

extension WKTConvertibleInternal {
    public func wkt() throws -> String {
        let context = try GEOSContext()
        let writer = try WKTWriter(
            context: context,
            useFixedPrecision: .geosDefault,
            roundingPrecision: .geosDefault)
        return try writer.write(self)
    }

    public func wkt(useFixedPrecision: Bool, roundingPrecision: Int32) throws -> String {
        let context = try GEOSContext()
        let writer = try WKTWriter(
            context: context,
            useFixedPrecision: .custom(useFixedPrecision),
            roundingPrecision: .custom(roundingPrecision))
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

    init(context: GEOSContext,
         useFixedPrecision: UseFixedPrecision,
         roundingPrecision: RoundingPrecision) throws {
        guard let writer = GEOSWKTWriter_create_r(context.handle) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        self.context = context
        self.writer = writer

        if case let .custom(value) = useFixedPrecision {
            GEOSWKTWriter_setTrim_r(context.handle, writer, value ? 1 : 0)
        }

        if case let .custom(value) = roundingPrecision {
            GEOSWKTWriter_setRoundingPrecision_r(context.handle, writer, value)
        }
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

    enum UseFixedPrecision {
        case geosDefault
        case custom(Bool)
    }

    enum RoundingPrecision {
        case geosDefault
        case custom(Int32)
    }
}
