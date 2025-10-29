import Foundation

public protocol WKBInitializable {
    init(wkb: Data) throws
}

protocol WKBInitializableInternal: WKBInitializable, GEOSObjectInitializable {}

extension WKBInitializableInternal {
    public init(wkb: Data) throws {
        let context = try GEOSContext()
        let reader = try WKBReader(context: context)
        
        try self.init(geosObject: try reader.read(wkb))
    }
}

extension Point: WKBInitializable, WKBInitializableInternal {}
extension LineString: WKBInitializable, WKBInitializableInternal {}
// Polygon.LinearRing is omitted since it's not representable in WKB
extension Polygon: WKBInitializable, WKBInitializableInternal {}
extension MultiPoint: WKBInitializable, WKBInitializableInternal {}
extension MultiLineString: WKBInitializable, WKBInitializableInternal {}
extension MultiPolygon: WKBInitializable, WKBInitializableInternal {}
extension GeometryCollection: WKBInitializable, WKBInitializableInternal {}
extension Geometry: WKBInitializable, WKBInitializableInternal {}
