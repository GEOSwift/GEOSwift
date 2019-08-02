import geos

extension MultiPoint: GEOSObjectInitializable {
    init(geosObject: GEOSObject) throws {
        guard case .some(.multiPoint) = geosObject.type else {
            throw GEOSError.typeMismatch(actual: geosObject.type, expected: .multiPoint)
        }
        self.init(points: try makeGeometries(geometry: geosObject))
    }
}

extension MultiPoint: GEOSObjectConvertible {
    func geosObject(with context: GEOSContext) throws -> GEOSObject {
        return try makeGEOSCollection(with: context, geometries: points, type: GEOS_MULTIPOINT)
    }
}
