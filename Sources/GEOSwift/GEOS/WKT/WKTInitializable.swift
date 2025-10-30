import Foundation

public protocol WKTInitializable {
    init(wkt: String) throws
}

protocol WKTInitializableInternal: WKTInitializable, GEOSObjectInitializable {}

extension WKTInitializableInternal {
    public init(wkt: String) throws {
        let context = try GEOSContext()
        let reader = try WKTReader(context: context)

        try self.init(geosObject: try reader.read(wkt))
    }
}

extension Point: WKTInitializable, WKTInitializableInternal {}
extension LineString: WKTInitializable, WKTInitializableInternal {}
extension Polygon.LinearRing: WKTInitializable, WKTInitializableInternal {}
extension Polygon: WKTInitializable, WKTInitializableInternal {}
extension MultiPoint: WKTInitializable, WKTInitializableInternal {}
extension MultiLineString: WKTInitializable, WKTInitializableInternal {}
extension MultiPolygon: WKTInitializable, WKTInitializableInternal {}
extension GeometryCollection: WKTInitializable, WKTInitializableInternal {}
extension Geometry: WKTInitializable, WKTInitializableInternal {}
