import geos

public final class GEOSContext {
    public let handle: GEOSContextHandle_t
    public fileprivate(set) var errors = [String]()

    public init() throws {
        guard let handle = GEOS_init_r() else {
            throw GEOSError.unableToCreateContext
        }
        self.handle = handle
        let selfPtr = Unmanaged.passUnretained(self).toOpaque()
        GEOSContext_setErrorMessageHandler_r(handle, handleError(message:userData:), selfPtr)
    }

    deinit {
        GEOS_finish_r(handle)
    }
}

private func handleError(message: UnsafePointer<Int8>?, userData: UnsafeMutableRawPointer?) {
    guard let message = message, let userData = userData else {
        return
    }
    let context: GEOSContext = Unmanaged.fromOpaque(userData).takeUnretainedValue()
    context.errors.append(String(cString: message))
}
