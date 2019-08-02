public enum GeoJSON: Hashable {
    case featureCollection(FeatureCollection)
    case feature(Feature)
    case geometry(Geometry)
}
