import Foundation
import GEOSwift

struct IdentifiablePoint: Identifiable, Hashable {
    var id = UUID()
    var point: Point<XY>
}

struct IdentifiableMultiPoint: Identifiable, Hashable {
    var id = UUID()
    var points: [IdentifiablePoint]
    var multiPoint: MultiPoint<XY>
    public init(multiPoint: MultiPoint<XY>) {
        self.points = multiPoint.points.map { point in
            IdentifiablePoint(point: point)
        }
        self.multiPoint = multiPoint
    }
}

struct IdentifiableLineString: Identifiable, Hashable {
    var id = UUID()
    var lineString: LineString<XY>
}

struct IdentifiableMultiLineString: Identifiable, Hashable {
    var id = UUID()
    var lineStrings: [IdentifiableLineString]
    var multiLineString: MultiLineString<XY>
    public init(multiLineString: MultiLineString<XY>) {
        self.lineStrings = multiLineString.lineStrings.map { lineString in
            IdentifiableLineString(lineString: lineString)
        }
        self.multiLineString = multiLineString
    }
}

struct IdentifiablePolygon: Identifiable, Hashable {
    var id = UUID()
    var polygon: Polygon<XY>
}

struct IdentifiableMultiPolygon: Identifiable, Hashable {
    var id = UUID()
    var polygons: [IdentifiablePolygon]
    var multiPolygon: MultiPolygon<XY>
    public init(multiPolygon: MultiPolygon<XY>) {
        self.polygons = multiPolygon.polygons.map { polygon in
            IdentifiablePolygon(polygon: polygon)
        }
        self.multiPolygon = multiPolygon
    }
}

struct IdentifiableGeometryCollection: Identifiable, Hashable {
    var id = UUID()
    var geometries: [IdentifiableGeometry]
    var geometryCollection: GeometryCollection<XY>
    public init(geometryCollection: GeometryCollection<XY>) {
        self.geometries = geometryCollection.geometries.map { geometry in
            IdentifiableGeometry(geometry)
        }
        self.geometryCollection = geometryCollection
    }
}
