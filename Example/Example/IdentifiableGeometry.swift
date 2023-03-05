import Foundation
import GEOSwift

struct IdentifiableGeometry: Identifiable, Hashable {
    let id = UUID()
    let geometry: Geometry
    var selected = false
    public init(geometry: Geometry, selected: Bool = false) {
        self.geometry = geometry
        self.selected = selected
    }
}

struct IdentifiablePoint: Identifiable, Hashable {
    var id = UUID()
    var point: Point
}

struct IdentifiableMultiPoint: Identifiable, Hashable {
    var id = UUID()
    var points: [IdentifiablePoint]
    public init(multiPoint: MultiPoint) {
        self.points = multiPoint.points.map { point in
            IdentifiablePoint(point: point)
        }
    }
}

struct IdentifiableLineString: Identifiable, Hashable {
    var id = UUID()
    var lineString: LineString
}

struct IdentifiableMultiLineString: Identifiable, Hashable {
    var id = UUID()
    var lineStrings: [IdentifiableLineString]
    public init(multiLineString: MultiLineString) {
        self.lineStrings = multiLineString.lineStrings.map { lineString in
            IdentifiableLineString(lineString: lineString)
        }
    }
}

struct IdentifiablePolygon: Identifiable, Hashable {
    var id = UUID()
    var polygon: Polygon
}

struct IdentifiableMultiPolygon: Identifiable, Hashable {
    var id = UUID()
    var polygons: [IdentifiablePolygon]
    public init(multiPolygon: MultiPolygon) {
        self.polygons = multiPolygon.polygons.map { polygon in
            IdentifiablePolygon(polygon: polygon)
        }
    }
}

struct IdentifiableGeometryCollection: Identifiable, Hashable {
    var id = UUID()
    var geometries: [IdentifiableGeometry]
    public init(geometryCollection: GeometryCollection) {
        self.geometries = geometryCollection.geometries.map { geometry in
            IdentifiableGeometry(geometry: geometry)
        }
    }
}
