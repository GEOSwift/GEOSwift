import geos

extension LineString: GEOSObjectInitializable {
    init(geosObject: GEOSObject) throws {
        guard case .some(.lineString) = geosObject.type else {
            throw GEOSError.typeMismatch(actual: geosObject.type, expected: .lineString)
        }
        try self.init(points: makePoints(from: geosObject))
    }
}

extension LineString: GEOSObjectConvertible {
    func geosObject(with context: GEOSContext) throws -> GEOSObject {
        return try makeGEOSObject(with: context, points: points) { (context, sequence) in
            GEOSGeom_createLineString_r(context.handle, sequence)
        }
    }
}
