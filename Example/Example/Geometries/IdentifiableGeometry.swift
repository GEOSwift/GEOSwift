import Foundation
import GEOSwift

enum IdentifiableGeometry: Identifiable, Hashable {
    case point(IdentifiablePoint)
    case multiPoint(IdentifiableMultiPoint)
    case lineString(IdentifiableLineString)
    case multiLineString(IdentifiableMultiLineString)
    case polygon(IdentifiablePolygon)
    case multiPolygon(IdentifiableMultiPolygon)
    case geometryCollection(IdentifiableGeometryCollection)
    
    var id: UUID {
        switch self {
        case .point(let identifiablePoint):
            return identifiablePoint.id
        case .multiPoint(let identifiableMultiPoint):
            return identifiableMultiPoint.id
        case .lineString(let identifiableLineString):
            return identifiableLineString.id
        case .multiLineString(let identifiableMultiLineString):
            return identifiableMultiLineString.id
        case .polygon(let identifiablePolygon):
            return identifiablePolygon.id
        case .multiPolygon(let identifiableMultiPolygon):
            return identifiableMultiPolygon.id
        case .geometryCollection(let identifiableGeometryCollection):
            return identifiableGeometryCollection.id
        }
    }
    
    var geometry: GeometryConvertible {
        switch self {
        case .point(let identifiablePoint):
            return identifiablePoint.point
        case .multiPoint(let identifiableMultiPoint):
            return identifiableMultiPoint.multiPoint
        case .lineString(let identifiableLineString):
            return identifiableLineString.lineString
        case .multiLineString(let identifiableMultiLineString):
            return identifiableMultiLineString.multiLineString
        case .polygon(let identifiablePolygon):
            return identifiablePolygon.polygon
        case .multiPolygon(let identifiableMultiPolygon):
            return identifiableMultiPolygon.multiPolygon
        case .geometryCollection(let identifiableGeometryCollection):
            return identifiableGeometryCollection.geometryCollection
        }
    }
    
    init(_ geometry: Geometry) {
        switch geometry {
        case .point(let point):
            self = .point(IdentifiablePoint(point: point))
        case .multiPoint(let multiPoint):
            self = .multiPoint(IdentifiableMultiPoint(multiPoint: multiPoint))
        case .lineString(let lineString):
            self = .lineString(IdentifiableLineString(lineString: lineString))
        case .multiLineString(let multiLineString):
            self = .multiLineString(IdentifiableMultiLineString(multiLineString: multiLineString))
        case .polygon(let polygon):
            self = .polygon(IdentifiablePolygon(polygon: polygon))
        case .multiPolygon(let multiPolygon):
            self = .multiPolygon(IdentifiableMultiPolygon(multiPolygon: multiPolygon))
        case .geometryCollection(let geometryCollection):
            self = .geometryCollection(IdentifiableGeometryCollection(geometryCollection: geometryCollection))
        }
    }
}
