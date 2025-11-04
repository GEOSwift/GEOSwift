import Foundation
import geos

public extension GeometryConvertible {
    /// Parameter mask: A DE9-IM mask pattern
    func relate<D: CoordinateType>(_ geometry: any GeometryConvertible<D>, mask: String) throws -> Bool {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let otherGeosObject = try geometry.geometry.geosObject(with: context)
        // returns 2 on exception, 1 on true, 0 on false
        let result = mask.withCString {
            GEOSRelatePattern_r(context.handle, geosObject.pointer, otherGeosObject.pointer, $0)
        }
        guard result != 2 else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return result == 1
    }

    func relate<D: CoordinateType>(_ geometry: any GeometryConvertible<D>) throws -> String {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let otherGeosObject = try geometry.geometry.geosObject(with: context)
        guard let cString = GEOSRelate_r(context.handle, geosObject.pointer, otherGeosObject.pointer) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        defer { GEOSFree_r(context.handle, cString) }
        return String(cString: cString)
    }
}
