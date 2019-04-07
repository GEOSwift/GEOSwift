import geos

extension MultiLineString: GEOSObjectInitializable {
    init(geosObject: GEOSObject) throws {
        guard case .some(.multiLineString) = geosObject.type else {
            throw GEOSError.typeMismatch(actual: geosObject.type, expected: .multiLineString)
        }
        self.init(lineStrings: try makeGeometries(geometry: geosObject))
    }
}

extension MultiLineString: GEOSObjectConvertible {
    func geosObject(with context: GEOSContext) throws -> GEOSObject {
        return try makeGEOSCollection(with: context, geometries: lineStrings, type: GEOS_MULTILINESTRING)
    }
}
