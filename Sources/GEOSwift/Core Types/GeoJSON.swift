public enum GeoJSON<C: CoordinateType>: Hashable, Sendable {
    case featureCollection(FeatureCollection<C>)
    case feature(Feature<C>)
    case geometry(Geometry<C>)
}
