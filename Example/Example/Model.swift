import Foundation
import GEOSwift

struct GeometryModification {
    var pointModel: Point = try! Point(wkt: "POINT(10 45)")
    var polygonModel: Polygon = try! Polygon(wkt: "POLYGON((50 50, 300 21, 120 200, 30 150, 50 50))")
    var polygonModel2: Polygon = try! Polygon(wkt: "POLYGON((50 50, 120 200, 30 150, 50 50))")
}
