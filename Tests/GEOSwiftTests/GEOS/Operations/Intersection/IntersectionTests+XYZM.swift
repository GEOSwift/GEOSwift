import XCTest
import GEOSwift

// MARK: - Tests

final class IntersectionTests_XYZM: OperationsTestCase_XYZM {

    // MARK: - XYZM ∩ XY → XYZM

    func testIntersectionXYZMWithXY() throws {
        let lineXY = try! LineString(coordinates: [
            XY(-1, 2),
            XY(2, -1)])
        let result: Geometry<XYZM>? = try unitPoly.intersection(with: lineXY)
        XCTAssertNotNil(result)
        if case let .lineString(lineString) = result {
            XCTAssertEqual(lineString.coordinates.count, 2)
        }
    }

    // MARK: - XYZM ∩ XYZ → XYZM

    func testIntersectionXYZMWithXYZ() throws {
        let lineXYZ = try! LineString(coordinates: [
            XYZ(-1, 2, 10),
            XYZ(2, -1, 20)])
        let result: Geometry<XYZM>? = try unitPoly.intersection(with: lineXYZ)
        XCTAssertNotNil(result)
        if case let .lineString(lineString) = result {
            XCTAssertEqual(lineString.coordinates.count, 2)
        }
    }

    // MARK: - XYZM ∩ XYM → XYZM

    func testIntersectionXYZMWithXYM() throws {
        let lineXYM = try! LineString(coordinates: [
            XYM(-1, 2, 100),
            XYM(2, -1, 200)])
        let result: Geometry<XYZM>? = try unitPoly.intersection(with: lineXYM)
        XCTAssertNotNil(result)
        if case let .lineString(lineString) = result {
            XCTAssertEqual(lineString.coordinates.count, 2)
        }
    }

    // MARK: - XYZM ∩ XYZM → XYZM

    func testIntersectionXYZMWithXYZM() throws {
        let line = try! LineString(coordinates: [
            XYZM(-1, 2, 10, 100),
            XYZM(2, -1, 20, 200)])
        let result: Geometry<XYZM>? = try unitPoly.intersection(with: line)
        XCTAssertNotNil(result)
        if case let .lineString(lineString) = result {
            XCTAssertEqual(lineString.coordinates.count, 2)
        }
    }

    func testIntersectionXYZMWithXYZMAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            XCTAssertNoThrow(try g1.intersection(with: g2) as Geometry<XYZM>?)
        }
    }
}
