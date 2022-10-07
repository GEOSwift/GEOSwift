import Foundation
import GEOSwift

enum Data {
    static let baseGeometry: Geometry = try! Geometry(wkt: "POLYGON((50 50, 300 21, 120 200, 30 150, 50 50))")
    static let secondGeometry: Geometry = try! Geometry(wkt: "POLYGON((40 50, 200 21, 120 210, 30 130, 40 50))")
}
