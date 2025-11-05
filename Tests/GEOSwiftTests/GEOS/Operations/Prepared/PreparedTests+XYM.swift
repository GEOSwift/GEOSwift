import XCTest
import GEOSwift

final class PreparedTests_XYM: XCTestCase {
    func testMakePreparedAllTypes() {
        for g in GEOSTestFixtures_XYM.geometryConvertibles {
            do {
                _ = try g.makePrepared()
            } catch {
                XCTFail("Unexpected error for \(g) makePrepared() \(error)")
            }
        }
    }
}
