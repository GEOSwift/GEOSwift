import Foundation

/// A protocol for geometries that can be initialized from Well-Known Text (WKT) format.
///
/// WKT is a text representation standard for geometric objects defined by the OGC.
///
/// See `GEOSWKTReader_read_r` in the
/// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html).
public protocol WKTInitializable {
    /// Creates a geometry from Well-Known Text (WKT) format.
    ///
    /// See `GEOSWKTReader_read_r` in the
    /// [GEOS C API](https://libgeos.org/doxygen/geos__c_8h.html).
    ///
    /// - Parameter wkt: The WKT string to parse.
    /// - Throws: `Error` if the WKT string is invalid or cannot be parsed.
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
