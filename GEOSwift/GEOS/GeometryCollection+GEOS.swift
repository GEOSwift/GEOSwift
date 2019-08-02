import geos

extension GeometryCollection: GEOSObjectInitializable {
    init(geosObject: GEOSObject) throws {
        guard case .some(.geometryCollection) = geosObject.type else {
            throw GEOSError.typeMismatch(actual: geosObject.type, expected: .geometryCollection)
        }
        self.geometries = try makeGeometries(geometry: geosObject)
    }
}

extension GeometryCollection: GEOSObjectConvertible {
    func geosObject(with context: GEOSContext) throws -> GEOSObject {
        return try makeGEOSCollection(with: context, geometries: geometries, type: GEOS_GEOMETRYCOLLECTION)
    }
}
