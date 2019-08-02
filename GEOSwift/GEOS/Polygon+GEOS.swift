import geos

extension Polygon.LinearRing: GEOSObjectInitializable {
    init(geosObject: GEOSObject) throws {
        guard case .some(.linearRing) = geosObject.type else {
            throw GEOSError.typeMismatch(actual: geosObject.type, expected: .linearRing)
        }
        try self.init(points: makePoints(from: geosObject))
    }
}

extension Polygon.LinearRing: GEOSObjectConvertible {
    func geosObject(with context: GEOSContext) throws -> GEOSObject {
        return try makeGEOSObject(with: context, points: points) { (context, sequence) in
            GEOSGeom_createLinearRing_r(context.handle, sequence)
        }
    }
}

extension Polygon: GEOSObjectInitializable {
    init(geosObject: GEOSObject) throws {
        guard case .some(.polygon) = geosObject.type else {
            throw GEOSError.typeMismatch(actual: geosObject.type, expected: .polygon)
        }
        // returns null on exception
        guard let exteriorRing = GEOSGetExteriorRing_r(geosObject.context.handle, geosObject.pointer) else {
            throw GEOSError.libraryError(errorMessages: geosObject.context.errors)
        }
        let exteriorRingObject = GEOSObject(parent: geosObject, pointer: exteriorRing)
        let exterior = try LinearRing(geosObject: exteriorRingObject)
        // returns -1 on exception
        let numInteriorRings = GEOSGetNumInteriorRings_r(geosObject.context.handle, geosObject.pointer)
        guard numInteriorRings >= 0 else {
            throw GEOSError.libraryError(errorMessages: geosObject.context.errors)
        }
        let holes = try Array(0..<numInteriorRings).map { (index) -> LinearRing in
            // returns null on exception
            guard let interiorRing = GEOSGetInteriorRingN_r(
                geosObject.context.handle, geosObject.pointer, index) else {
                    throw GEOSError.libraryError(errorMessages: geosObject.context.errors)
            }
            let interiorRingObject = GEOSObject(parent: geosObject, pointer: interiorRing)
            return try LinearRing(geosObject: interiorRingObject)
        }
        self.init(exterior: exterior, holes: holes)
    }
}

extension Polygon: GEOSObjectConvertible {
    func geosObject(with context: GEOSContext) throws -> GEOSObject {
        let exterior = try self.exterior.geosObject(with: context)
        let holes = try self.holes.map { try $0.geosObject(with: context) }
        var holesArray = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: holes.count)
        defer { holesArray.deallocate() }
        holes.enumerated().forEach { (i, hole) in
            holesArray[i] = hole.pointer
        }
        guard let polygonPointer = GEOSGeom_createPolygon_r(
            context.handle, exterior.pointer, holesArray, UInt32(holes.count)) else {
                throw GEOSError.libraryError(errorMessages: context.errors)
        }
        // upon success, exterior and holes are now owned by the polygon
        // it's essential to set their parent properties so that they
        // do not destory their geometries upon deinit.
        let polygon = GEOSObject(context: context, pointer: polygonPointer)
        exterior.parent = polygon
        holes.forEach { $0.parent = polygon }
        return polygon
    }
}
