public enum GeoJSON: Hashable, Sendable {
    case featureCollection(FeatureCollection)
    case feature(Feature)
    case geometry(Geometry)
}
