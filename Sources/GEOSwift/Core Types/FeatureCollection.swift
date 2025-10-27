/// A GeoJSON FeatureCollection representing a collection of zero or more ``Feature``s.
///
/// The underlying ``CoordinateType`` (e.g. ``XY``, ``XYZ``) determines the dimensionality of the geometries.
public struct FeatureCollection<C: CoordinateType>: Hashable, Sendable {
    /// The features in the `FeatureCollection`
    public var features: [Feature<C>]

    /// Initialize a `FeatureCollection` from the given features.
    /// - parameters:
    ///   - features: An array of features.
    public init(features: [Feature<C>]) {
        self.features = features
    }
}
