import XCTest
import GEOSwift

final class PreparedTests_XYZ: XCTestCase {
    func testMakePreparedAllTypes() {
        for g in GEOSTestFixtures_XYZ.geometryConvertibles {
            do {
                _ = try g.makePrepared()
            } catch {
                XCTFail("Unexpected error for \(g) makePrepared() \(error)")
            }
        }
    }
}
