import geos

func makeGeometries<T>(geometry: GEOSObject) throws -> [T] where T: GEOSObjectInitializable {
    let numGeometries = GEOSGetNumGeometries_r(geometry.context.handle, geometry.pointer)
    guard numGeometries >= 0 else {
        throw GEOSError.libraryError(errorMessages: geometry.context.errors)
    }
    return try Array(0..<numGeometries).map { (index) -> T in
        // returns null on exception
        guard let pointer = GEOSGetGeometryN_r(geometry.context.handle, geometry.pointer, index) else {
            throw GEOSError.libraryError(errorMessages: geometry.context.errors)
        }
        return try T(geosObject: GEOSObject(parent: geometry, pointer: pointer))
    }
}

func makePoints(from geometry: GEOSObject) throws -> [Point] {
    guard let sequence = GEOSGeom_getCoordSeq_r(geometry.context.handle, geometry.pointer) else {
        throw GEOSError.libraryError(errorMessages: geometry.context.errors)
    }
    var count: UInt32 = 0
    // returns 0 on exception
    guard GEOSCoordSeq_getSize_r(geometry.context.handle, sequence, &count) != 0 else {
        throw GEOSError.libraryError(errorMessages: geometry.context.errors)
    }
    return try Array(0..<count).map { (index) -> Point in
        var point = Point(x: 0, y: 0)
        // returns 0 on exception
        guard GEOSCoordSeq_getX_r(geometry.context.handle, sequence, index, &point.x) != 0,
            GEOSCoordSeq_getY_r(geometry.context.handle, sequence, index, &point.y) != 0 else {
                throw GEOSError.libraryError(errorMessages: geometry.context.errors)
        }
        return point
    }
}

func makeCoordinateSequence(with context: GEOSContext, points: [Point]) throws -> OpaquePointer {
    guard let sequence = GEOSCoordSeq_create_r(context.handle, UInt32(points.count), 2) else {
        throw GEOSError.libraryError(errorMessages: context.errors)
    }
    try points.enumerated().forEach { (i, point) in
        guard GEOSCoordSeq_setX_r(context.handle, sequence, UInt32(i), point.x) != 0,
            GEOSCoordSeq_setY_r(context.handle, sequence, UInt32(i), point.y) != 0 else {
                GEOSCoordSeq_destroy_r(context.handle, sequence)
                throw GEOSError.libraryError(errorMessages: context.errors)
        }
    }
    return sequence
}

func makeGEOSObject(
    with context: GEOSContext,
    points: [Point],
    factory: (GEOSContext, OpaquePointer) -> OpaquePointer?) throws -> GEOSObject {

    let sequence = try makeCoordinateSequence(with: context, points: points)
    guard let geometry = factory(context, sequence) else {
        GEOSCoordSeq_destroy_r(context.handle, sequence)
        throw GEOSError.libraryError(errorMessages: context.errors)
    }
    return GEOSObject(context: context, pointer: geometry)
}

func makeGEOSCollection(
    with context: GEOSContext,
    geometries: [GEOSObjectConvertible],
    type: GEOSGeomTypes) throws -> GEOSObject {

    let geosObjects = try geometries.map { try $0.geosObject(with: context) }
    var geosPointersArray = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: geosObjects.count)
    defer { geosPointersArray.deallocate() }
    geosObjects.enumerated().forEach { (i, geosObject) in
        geosPointersArray[i] = geosObject.pointer
    }
    guard let collectionPointer = GEOSGeom_createCollection_r(
        context.handle, Int32(type.rawValue), geosPointersArray, UInt32(geosObjects.count)) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
    }
    // upon success, geosObjects' pointees are now owned by the collection
    // it's essential to set their parent properties so that they do not
    // destory their pointees upon deinit.
    let collection = GEOSObject(context: context, pointer: collectionPointer)
    geosObjects.forEach { $0.parent = collection }
    return collection
}
