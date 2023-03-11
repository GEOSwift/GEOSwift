public enum GEOSError: Error, Hashable, Sendable {
    case unableToCreateContext
    case libraryError(errorMessages: [String])
    case wkbDataWasEmpty
    case typeMismatch(actual: GEOSObjectType?, expected: GEOSObjectType)
    case noMinimumBoundingCircle
}
