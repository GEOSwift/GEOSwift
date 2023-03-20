import Foundation
import GEOSwift

struct IdentifiablePoint: Identifiable, Hashable {
    var id = UUID()
    var point: Point
}

struct IdentifiableMultiPoint: Identifiable, Hashable {
    var id = UUID()
    var points: [IdentifiablePoint]
    var multiPoint: MultiPoint
    public init(multiPoint: MultiPoint) {
        self.points = multiPoint.points.map { point in
            IdentifiablePoint(point: point)
        }
        self.multiPoint = multiPoint
    }
}

struct IdentifiableLineString: Identifiable, Hashable {
    var id = UUID()
    var lineString: LineString
}

struct IdentifiableMultiLineString: Identifiable, Hashable {
    var id = UUID()
    var lineStrings: [IdentifiableLineString]
    var multiLineString: MultiLineString
    public init(multiLineString: MultiLineString) {
        self.lineStrings = multiLineString.lineStrings.map { lineString in
            IdentifiableLineString(lineString: lineString)
        }
        self.multiLineString = multiLineString
    }
}

struct IdentifiablePolygon: Identifiable, Hashable {
    var id = UUID()
    var polygon: Polygon
}

struct IdentifiableMultiPolygon: Identifiable, Hashable {
    var id = UUID()
    var polygons: [IdentifiablePolygon]
    var multiPolygon: MultiPolygon
    public init(multiPolygon: MultiPolygon) {
        self.polygons = multiPolygon.polygons.map { polygon in
            IdentifiablePolygon(polygon: polygon)
        }
        self.multiPolygon = multiPolygon
    }
}

struct IdentifiableGeometryCollection: Identifiable, Hashable {
    var id = UUID()
    var geometries: [IdentifiableGeometry]
    var geometryCollection: GeometryCollection
    public init(geometryCollection: GeometryCollection) {
        self.geometries = geometryCollection.geometries.map { geometry in
            IdentifiableGeometry(geometry)
        }
        self.geometryCollection = geometryCollection
    }
}
