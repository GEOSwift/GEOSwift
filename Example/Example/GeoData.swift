import Foundation
import GEOSwift

enum GeoData {
    static let baseGeometry: Geometry = try! Geometry(wkt: "POLYGON((50 50, 300 21, 120 200, 30 150, 50 50))")
    static let secondGeometry: Geometry = try! Geometry(wkt: "POLYGON((40 50, 200 21, 120 210, 30 130, 40 50))")
    static let baseCircle: Circle = Circle(center: Point(x: 54, y: 34), radius: 34)
    static let polygon = try! Polygon(exterior:
                                        GEOSwift.Polygon.LinearRing(points: [GEOSwift.Point(x: 40, y: 50.0), GEOSwift.Point(x: 200, y: 21), GEOSwift.Point(x: 120, y: 210), GEOSwift.Point(x: 40, y: 50)]),
                                      holes: [
                                        GEOSwift.Polygon.LinearRing(points: [GEOSwift.Point(x: 45.0, y: 55.0), GEOSwift.Point(x: 170.0, y: 36.0), GEOSwift.Point(x: 120.0, y: 150.0), GEOSwift.Point(x: 35.0, y: 39.0), GEOSwift.Point(x: 45.0, y: 55.0)]),
                                        GEOSwift.Polygon.LinearRing(points: [GEOSwift.Point(x: 70.0, y: 70.0), GEOSwift.Point(x: 80, y: 70), GEOSwift.Point(x: 80, y: 80), GEOSwift.Point(x: 70, y: 70), GEOSwift.Point(x: 70, y: 70)])
                                      ])
}
