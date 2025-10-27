import Foundation

/// A marker protocol indicating that a coordinate type can be encoded/decoded as GeoJSON.
///
/// Conforming types: ``XY``, ``XYZ``
public protocol GeoJSONCoordinate: Codable {}
