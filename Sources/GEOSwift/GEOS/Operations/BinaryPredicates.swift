import Foundation
import geos

public extension GeometryConvertible {
    private typealias BinaryPredicate = (GEOSContextHandle_t, OpaquePointer, OpaquePointer) -> Int8

    private func evaluateBinaryPredicate<D: CoordinateType>(
        _ predicate: BinaryPredicate,
        with geometry: any GeometryConvertible<D>
    ) throws -> Bool {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let otherGeosObject = try geometry.geometry.geosObject(with: context)
        // returns 2 on exception, 1 on true, 0 on false
        let result = predicate(context.handle, geosObject.pointer, otherGeosObject.pointer)
        guard result != 2 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return result == 1
    }

    func isTopologicallyEquivalent<D: CoordinateType>(to geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSEquals_r, with: geometry)
    }

    func isDisjoint<D: CoordinateType>(with geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSDisjoint_r, with: geometry)
    }

    func touches<D: CoordinateType>(_ geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSTouches_r, with: geometry)
    }

    func intersects<D: CoordinateType>(_ geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSIntersects_r, with: geometry)
    }

    func crosses<D: CoordinateType>(_ geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSCrosses_r, with: geometry)
    }

    func isWithin<D: CoordinateType>(_ geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSWithin_r, with: geometry)
    }

    func contains<D: CoordinateType>(_ geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSContains_r, with: geometry)
    }

    func overlaps<D: CoordinateType>(_ geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSOverlaps_r, with: geometry)
    }

    func covers<D: CoordinateType>(_ geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSCovers_r, with: geometry)
    }

    func isCovered<D: CoordinateType>(by geometry: any GeometryConvertible<D>) throws -> Bool {
        try evaluateBinaryPredicate(GEOSCoveredBy_r, with: geometry)
    }
}
