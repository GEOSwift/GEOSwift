public enum GEOSError: Error {
    case unableToCreateContext
    case libraryError(errorMessages: [String])
    case wkbDataWasEmpty
    case typeMismatch(actual: GEOSObjectType?, expected: GEOSObjectType)
}
