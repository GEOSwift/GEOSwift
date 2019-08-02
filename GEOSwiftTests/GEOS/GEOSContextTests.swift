import XCTest
import geos
@testable import GEOSwift

final class GEOSContextTests: GEOSContextTestCase {
    func testCapturesErrorMessages() {
        // pass in some invalid WKT
        let invalidWKT = "hello"
        let pointer = GEOSWKTReader_create_r(context.handle)

        if let geometry = invalidWKT.withCString({ GEOSWKTReader_read_r(context.handle, pointer, $0) }) {
            GEOSGeom_destroy_r(context.handle, geometry)
            XCTFail("Expected WKT reading to fail")
        }

        XCTAssertEqual(context.errors.count, 1)

        GEOSWKTReader_destroy_r(context.handle, pointer)
    }
}
