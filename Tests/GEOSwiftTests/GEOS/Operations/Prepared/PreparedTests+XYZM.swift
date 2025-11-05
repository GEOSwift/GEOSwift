import XCTest
import GEOSwift

final class PreparedTests_XYZM: XCTestCase {
    // Geometry convertibles array from Fixtures
    lazy var geometryConvertibles: [any GeometryConvertible<XYZM>] = Fixtures.allGeometryConvertibles

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
