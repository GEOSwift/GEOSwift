import XCTest
import GEOSwift

// MARK: - Tests

final class ConcaveHullTests_XYM: GEOSTestCase_XYM {

    func testConcaveHullAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.concaveHull(withRatio: .random(in: 0...1), allowHoles: .random())
            } catch {
                XCTFail("Unexpected error for \(g) concaveHull() \(error)")
            }
        }
    }
}
