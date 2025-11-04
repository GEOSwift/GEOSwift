import Foundation
import geos

public extension GeometryConvertible {
    func convexHull() throws -> Geometry<XY> {
        try performUnaryTopologyOperation(GEOSConvexHull_r)
    }
    
    func convexHull() throws -> Geometry<XYZ> where C: HasZ {
        try performUnaryTopologyOperation(GEOSConvexHull_r)
    }
}
