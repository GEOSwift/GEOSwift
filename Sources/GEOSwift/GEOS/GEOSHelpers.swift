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

func makePoints<C: CoordinateType>(from geometry: GEOSObject) throws -> [Point<C>] {
    guard let sequence = GEOSGeom_getCoordSeq_r(geometry.context.handle, geometry.pointer) else {
        throw GEOSError.libraryError(errorMessages: geometry.context.errors)
    }
    var count: UInt32 = 0
    // returns 0 on exception
    guard GEOSCoordSeq_getSize_r(geometry.context.handle, sequence, &count) != 0 else {
        throw GEOSError.libraryError(errorMessages: geometry.context.errors)
    }
    return try Array(0..<count).map { (index) -> Point in
        let coordinate = try C.bridge.getter(geometry.context, sequence, Int32(index))
        return Point(coordinate)
    }
}

func makeCoordinateSequence<C: CoordinateType>(with context: GEOSContext, points: [Point<C>]) throws -> OpaquePointer {
    guard let sequence = GEOSCoordSeq_createWithDimensions_r(context.handle, UInt32(points.count), Int32(C.hasZ), Int32(C.hasM)) else {
        throw GEOSError.libraryError(errorMessages: context.errors)
    }
    try points.enumerated().forEach { (i, point) in
        try C.bridge.setter(context, sequence, Int32(i), point.coordinates)
    }
    return sequence
}

func makeGEOSObject<C: CoordinateType>(
    with context: GEOSContext,
    points: [Point<C>],
    factory: (GEOSContext, OpaquePointer) -> OpaquePointer?
) throws -> GEOSObject {
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
    type: GEOSGeomTypes
) throws -> GEOSObject {
    let geosObjects = try geometries.map { try $0.geosObject(with: context) }
    let geosPointersArray = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: geosObjects.count)
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

fileprivate extension Int32 {
    init(_ bool: Bool) {
        self = bool ? 1 : 0
    }
}
