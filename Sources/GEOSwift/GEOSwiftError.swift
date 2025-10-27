public enum GEOSwiftError: Error, Hashable, Sendable {
    case invalidJSON
    case invalidGeoJSONType
    case invalidCoordinates
    case mismatchedGeoJSONType
    case tooFewCoordinates
    case ringNotClosed
    case tooFewRings
    case invalidFeatureId
    case unexpectedEnvelopeResult(AnyGeometry)
}
