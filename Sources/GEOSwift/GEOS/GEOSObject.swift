import geos

public enum GEOSObjectType {
    case point
    case lineString
    case linearRing
    case polygon
    case multiPoint
    case multiLineString
    case multiPolygon
    case geometryCollection
}

protocol GEOSObjectInitializable {
    init(geosObject: GEOSObject) throws
}

protocol GEOSObjectConvertible {
    func geosObject(with context: GEOSContext) throws -> GEOSObject
}

final class GEOSObject {
    let context: GEOSContext
    let pointer: OpaquePointer
    var parent: GEOSObject? {
        didSet {
            // make sure we're not mixing objects from different contexts
            precondition(parent == nil || parent?.context === context)
        }
    }

    init(context: GEOSContext, pointer: OpaquePointer) {
        self.context = context
        self.pointer = pointer
    }

    init(parent: GEOSObject, pointer: OpaquePointer) {
        self.context = parent.context
        self.pointer = pointer
        self.parent = parent
    }

    deinit {
        if parent == nil {
            GEOSGeom_destroy_r(context.handle, pointer)
        }
    }

    var type: GEOSObjectType? {
        // returns negative upon error
        let value = GEOSGeomTypeId_r(context.handle, pointer)
        guard value >= 0 else {
            return nil
        }
        switch GEOSGeomTypes(UInt32(value)) {
        case GEOS_POINT:
            return .point
        case GEOS_LINESTRING:
            return .lineString
        case GEOS_LINEARRING:
            return .linearRing
        case GEOS_POLYGON:
            return .polygon
        case GEOS_MULTIPOINT:
            return .multiPoint
        case GEOS_MULTILINESTRING:
            return .multiLineString
        case GEOS_MULTIPOLYGON:
            return .multiPolygon
        case GEOS_GEOMETRYCOLLECTION:
            return .geometryCollection
        default:
            return nil
        }
    }
}
