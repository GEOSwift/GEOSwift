import geos

extension Point: GEOSObjectInitializable {
    init(geosObject: GEOSObject) throws {
        guard case .some(.point) = geosObject.type else {
            throw GEOSError.typeMismatch(actual: geosObject.type, expected: .point)
        }
        let isEmpty = GEOSisEmpty_r(geosObject.context.handle, geosObject.pointer)
        // returns 2 on error
        guard isEmpty != 2 else {
            throw GEOSError.libraryError(errorMessages: geosObject.context.errors)
        }
        // returns 0 on false (non-empty)
        guard isEmpty == 0 else {
            throw GEOSwiftError.tooFewPoints
        }
        // returns nil on failure
        guard let cSeq = GEOSGeom_getCoordSeq_r(geosObject.context.handle, geosObject.pointer) else {
            throw GEOSError.libraryError(errorMessages: geosObject.context.errors)
        }
        
        let coordinate = try C.bridge.getter(geosObject.context, cSeq, 0)
        self.init(coordinate)
    }
}

extension Point: GEOSObjectConvertible {
    func geosObject(with context: GEOSContext) throws -> GEOSObject {
        try makeGEOSObject(with: context, points: [self]) { (context, sequence) in
            GEOSGeom_createPoint_r(context.handle, sequence)
        }
    }
}
