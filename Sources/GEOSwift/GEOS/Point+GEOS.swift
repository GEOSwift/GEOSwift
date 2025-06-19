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
        var x: Double = 0
        var y: Double = 0
        var z: Double?
        let hasZ = GEOSGeom_getCoordinateDimension_r(geosObject.context.handle, geosObject.pointer) > 2
        // returns 1 on success
        guard GEOSGeomGetX_r(geosObject.context.handle, geosObject.pointer, &x) == 1,
            GEOSGeomGetY_r(geosObject.context.handle, geosObject.pointer, &y) == 1 else {
                throw GEOSError.libraryError(errorMessages: geosObject.context.errors)
        }
        
        if hasZ {
            var zVal: Double = 0
            guard GEOSGeomGetZ_r(geosObject.context.handle, geosObject.pointer, &zVal) == 1 else {
                throw GEOSError.libraryError(errorMessages: geosObject.context.errors)
            }
            z = zVal
        }

        self.init(x: x, y: y, z: z)
    }
}

extension Point: GEOSObjectConvertible {
    func geosObject(with context: GEOSContext) throws -> GEOSObject {
        try makeGEOSObject(with: context, points: [self]) { (context, sequence) in
            GEOSGeom_createPoint_r(context.handle, sequence)
        }
    }
}
