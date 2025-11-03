import Foundation
import geos

// MARK: - Input/Output types

public enum IsValidDetailResult<C: CoordinateType>: Hashable, Sendable {
    case valid
    case invalid(reason: String?, location: Geometry<C>?)
}

public enum MakeValidMethod {
    case linework
    case structure(keepCollapsed: Bool)

    var geosMethod: GEOSMakeValidMethods {
        switch self {
        case .linework:
            return GEOS_MAKE_VALID_LINEWORK
        case .structure:
            return GEOS_MAKE_VALID_STRUCTURE
        }
    }

    var keepCollapsed: Int32? {
        switch self {
        case .linework:
            return nil
        case .structure(let keepCollapsed):
            return keepCollapsed ? 1 : 0
        }
    }
}

// MARK: - Validity operations

public extension GeometryConvertible {
    
    // MARK: IsValid
    
    func isValid() throws -> Bool {
        try evaluateUnaryPredicate(GEOSisValid_r)
    }

    func isValidReason() throws -> String {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        
        guard let cString = GEOSisValidReason_r(context.handle, geosObject.pointer) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        defer { GEOSFree_r(context.handle, cString) }
        
        return String(cString: cString)
    }

    func isValidDetail(allowSelfTouchingRingFormingHole: Bool = false) throws -> IsValidDetailResult<C> {
        let context = try GEOSContext()
        let geosObject = try self.geometry.geosObject(with: context)
        let flags: Int32 = allowSelfTouchingRingFormingHole
            ? Int32(GEOSVALID_ALLOW_SELFTOUCHING_RING_FORMING_HOLE.rawValue)
            : 0
        var optionalReason: UnsafeMutablePointer<Int8>?
        var optionalLocation: OpaquePointer?
        
        switch GEOSisValidDetail_r(
            context.handle, geosObject.pointer, flags, &optionalReason, &optionalLocation) {
        case 1: // Valid
            if let reason = optionalReason {
                GEOSFree_r(context.handle, reason)
            }
            if let location = optionalLocation {
                GEOSGeom_destroy_r(context.handle, location)
            }
            return .valid
        case 0: // Invalid
            let reason = optionalReason.map { (reason) -> String in
                defer { GEOSFree_r(context.handle, reason) }
                return String(cString: reason)
            }
            let location = try optionalLocation.map { (location) -> Geometry<C> in
                let locationGEOSObject = GEOSObject(context: context, pointer: location)
                return try Geometry(geosObject: locationGEOSObject)
            }
            return .invalid(reason: reason, location: location)
        default: // Error
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
    }
    
    // MARK: MakeValid
    
    func makeValid() throws -> Geometry<XY> {
        try performUnaryTopologyOperation(GEOSMakeValid_r)
    }
    
    func makeValid() throws -> Geometry<XYZ> where C: HasZ {
        try performUnaryTopologyOperation(GEOSMakeValid_r)
    }

    // TODO: Provide higher dimensionality output where possible. Preserves Z, drops M.
    func makeValid(method: MakeValidMethod) throws -> Geometry<XY> {
        let context = try GEOSContext()
        let geosObject = try geometry.geosObject(with: context)
        let params = MakeValidParams(context: context, method: method)
        guard let pointer = GEOSMakeValidWithParams_r(
            context.handle,
            geosObject.pointer,
            params.pointer
        ) else {
            throw GEOSError.libraryError(errorMessages: context.errors)
        }
        return try Geometry(geosObject: GEOSObject(context: context, pointer: pointer))
    }
}

// MARK: - Internal Helpers

private class MakeValidParams {
    let context: GEOSContext
    let pointer: OpaquePointer

    init(context: GEOSContext, method: MakeValidMethod) {
        self.context = context
        self.pointer = GEOSMakeValidParams_create_r(context.handle)
        assert(GEOSMakeValidParams_setMethod_r(context.handle, pointer, method.geosMethod) == 1)
        if let keepCollapsed = method.keepCollapsed {
            assert(GEOSMakeValidParams_setKeepCollapsed_r(context.handle, pointer, keepCollapsed) == 1)
        }
    }

    deinit {
        GEOSMakeValidParams_destroy_r(context.handle, pointer)
    }
}
