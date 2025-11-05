import XCTest
import GEOSwift

final class PreparedTests_XYZM: GEOSTestCase_XYZM {

    func testMakePreparedAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.makePrepared()
            } catch {
                XCTFail("Unexpected error for \(g) makePrepared() \(error)")
            }
        }
    }
}
