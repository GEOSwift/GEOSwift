import XCTest
import GEOSwift

// MARK: - Tests

final class IntersectionTests_XYM: GEOSTestCase_XYM {

    // MARK: - XYM ∩ XY → XYM

    func testIntersectionXYMWithXY() throws {
        let lineXY = try! LineString(coordinates: [
            XY(-1, 2),
            XY(2, -1)])
        let result: Geometry<XYM>? = try unitPoly.intersection(with: lineXY)
        XCTAssertNotNil(result)
        if case let .lineString(lineString) = result {
            XCTAssertEqual(lineString.coordinates.count, 2)
        }
    }

    // MARK: - XYM ∩ XYZ → XYZM

    func testIntersectionXYMWithXYZ() throws {
        let lineXYZ = try! LineString(coordinates: [
            XYZ(-1, 2, 10),
            XYZ(2, -1, 20)])
        let result: Geometry<XYZM>? = try unitPoly.intersection(with: lineXYZ)
        XCTAssertNotNil(result)
        if case let .lineString(lineString) = result {
            XCTAssertEqual(lineString.coordinates.count, 2)
        }
    }

    // MARK: - XYM ∩ XYM → XYM

    func testIntersectionXYMWithXYM() throws {
        let line = try! LineString(coordinates: [
            XYM(-1, 2, 100),
            XYM(2, -1, 200)])
        let result: Geometry<XYM>? = try unitPoly.intersection(with: line)
        XCTAssertNotNil(result)
        if case let .lineString(lineString) = result {
            XCTAssertEqual(lineString.coordinates.count, 2)
        }
    }

    func testIntersectionXYMWithXYMAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            XCTAssertNoThrow(try g1.intersection(with: g2) as Geometry<XYM>?)
        }
    }

    // MARK: - XYM ∩ XYZM → XYZM

    func testIntersectionXYMWithXYZM() throws {
        let lineXYZM = try! LineString(coordinates: [
            XYZM(-1, 2, 10, 100),
            XYZM(2, -1, 20, 200)])
        let result: Geometry<XYZM>? = try unitPoly.intersection(with: lineXYZM)
        XCTAssertNotNil(result)
        if case let .lineString(lineString) = result {
            XCTAssertEqual(lineString.coordinates.count, 2)
        }
    }
}
