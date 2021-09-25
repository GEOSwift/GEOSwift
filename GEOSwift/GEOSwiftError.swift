public enum GEOSwiftError: Error, Equatable {
    case invalidJSON
    case invalidGeoJSONType
    case invalidCoordinates
    case mismatchedGeoJSONType
    case tooFewPoints
    case ringNotClosed
    case tooFewRings
    case invalidFeatureId
    case lengthIsZero
    case unexpectedEnvelopeResult(Geometry)
}
