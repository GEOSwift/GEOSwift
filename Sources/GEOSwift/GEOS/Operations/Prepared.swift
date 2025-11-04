import Foundation
import geos

public extension GeometryConvertible {
    func makePrepared() throws -> PreparedGeometry<C> {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)
        return try PreparedGeometry(context: context, base: geosObject)
    }
}
