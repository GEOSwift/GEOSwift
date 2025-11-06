import Foundation

/// A protocol for geometries that can be initialized from Well-Known Binary (WKB) format.
///
/// WKB is a binary representation standard for geometric objects defined by the OGC.
///
/// See `GEOSWKBReader_read_r` in the
/// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html).
public protocol WKBInitializable {
    /// Creates a geometry from Well-Known Binary (WKB) data.
    ///
    /// See `GEOSWKBReader_read_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html).
    ///
    /// - Parameter wkb: The WKB data to parse.
    /// - Throws: `Error` if the WKB data is invalid or cannot be parsed.
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
