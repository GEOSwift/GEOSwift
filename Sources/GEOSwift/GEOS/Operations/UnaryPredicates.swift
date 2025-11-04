import Foundation
import geos

public extension GeometryConvertible {
    internal typealias UnaryPredicate = (GEOSContextHandle_t, OpaquePointer) -> Int8

    internal func evaluateUnaryPredicate(_ predicate: UnaryPredicate) throws -> Bool {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)
        // returns 2 on exception, 1 on true, 0 on false
        let result = predicate(context.handle, geosObject.pointer)
        guard result != 2 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return result == 1
    }

    func isEmpty() throws -> Bool {
        try evaluateUnaryPredicate(GEOSisEmpty_r)
    }

    func isRing() throws -> Bool {
        try evaluateUnaryPredicate(GEOSisRing_r)
    }
}
