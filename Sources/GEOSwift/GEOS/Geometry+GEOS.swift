extension Geometry: GEOSObjectInitializable {
    init(geosObject: GEOSObject) throws {
        guard let type = geosObject.type else {
            throw GEOSError.libraryError(errorMessages: geosObject.context.errors)
        }
        switch type {
        case .point:
            self = try Point(geosObject: geosObject).geometry
        case .lineString:
            self = try LineString(geosObject: geosObject).geometry
        case .linearRing:
            self = try Polygon.LinearRing(geosObject: geosObject).geometry
        case .polygon:
            self = try Polygon(geosObject: geosObject).geometry
        case .multiPoint:
            self = try MultiPoint(geosObject: geosObject).geometry
        case .multiLineString:
            self = try MultiLineString(geosObject: geosObject).geometry
        case .multiPolygon:
            self = try MultiPolygon(geosObject: geosObject).geometry
        case .geometryCollection:
            self = try GeometryCollection(geosObject: geosObject).geometry
        }
    }
}

extension Geometry: GEOSObjectConvertible {
    func geosObject(with context: GEOSContext) throws -> GEOSObject {
        switch self {
        case let .point(point):
            return try point.geosObject(with: context)
        case let .lineString(lineString):
            return try lineString.geosObject(with: context)
        case let .polygon(polygon):
            return try polygon.geosObject(with: context)
        case let .multiPoint(multiPoint):
            return try multiPoint.geosObject(with: context)
        case let .multiLineString(multiLineString):
            return try multiLineString.geosObject(with: context)
        case let .multiPolygon(multiPolygon):
            return try multiPolygon.geosObject(with: context)
        case let .geometryCollection(geometryCollection):
            return try geometryCollection.geosObject(with: context)
        }
    }
}
