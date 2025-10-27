import geos

extension LineString: GEOSObjectInitializable {
    init(geosObject: GEOSObject) throws {
        guard case .some(.lineString) = geosObject.type else {
            throw GEOSError.typeMismatch(actual: geosObject.type, expected: .lineString)
        }
        try self.init(coordinates: makeCoordinates(from: geosObject))
    }
}

extension LineString: GEOSObjectConvertible {
    func geosObject(with context: GEOSContext) throws -> GEOSObject {
        try makeGEOSObject(with: context, coordinates: coordinates) { (context, sequence) in
            GEOSGeom_createLineString_r(context.handle, sequence)
        }
    }
}
