import XCTest
import GEOSwift

final class PreparedTests: XCTestCase {
    func testMakePreparedAllTypes() {
        for g in GEOSTestFixtures.geometryConvertibles {
            do {
                _ = try g.makePrepared()
            } catch {
                XCTFail("Unexpected error for \(g) makePrepared() \(error)")
            }
        }
    }
}
