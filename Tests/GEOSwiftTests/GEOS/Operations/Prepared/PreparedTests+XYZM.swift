import XCTest
import GEOSwift

final class PreparedTests_XYZM: XCTestCase {
    func testMakePreparedAllTypes() {
        for g in GEOSTestFixtures_XYZM.geometryConvertibles {
            do {
                _ = try g.makePrepared()
            } catch {
                XCTFail("Unexpected error for \(g) makePrepared() \(error)")
            }
        }
    }
}
