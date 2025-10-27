/// A top-level GeoJSON object that can represent a ``FeatureCollection``, ``Feature``, or ``Geometry``.
///
/// The underlying ``CoordinateType`` (e.g. ``XY``, ``XYZ``) determines the dimensionality.
public enum GeoJSON<C: CoordinateType>: Hashable, Sendable {
    /// A ``FeatureCollection`` GeoJSON object
    case featureCollection(FeatureCollection<C>)
    /// A ``Feature`` GeoJSON object
    case feature(Feature<C>)
    /// A ``Geometry`` GeoJSON object
    case geometry(Geometry<C>)
}
