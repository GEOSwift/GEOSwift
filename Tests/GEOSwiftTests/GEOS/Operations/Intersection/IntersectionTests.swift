import XCTest
import GEOSwift

final class IntersectionTests: OperationsTestCase_XY {

    // MARK: - XY ∩ XY → XY

    func testIntersectionXYWithXY() {
        let line = try! LineString(coordinates: [
            XY(-1, 2),
            XY(2, -1)])
        let expectedLine = try! LineString(coordinates: [
            XY(0, 1),
            XY(1, 0)])
        XCTAssertEqual(try? unitPoly.intersection(with: line), .lineString(expectedLine))
    }

    func testIntersectionXYWithXYAllPairs() {
        for (g1, g2) in geometryConvertibles.allPairs {
            XCTAssertNoThrow(try g1.intersection(with: g2) as Geometry<XY>?)
        }
    }

    // MARK: - XY ∩ XYZ → XYZ

    func testIntersectionXYWithXYZ() throws {
        let lineXYZ = try! LineString(coordinates: [
            XYZ(-1, 2, 10),
            XYZ(2, -1, 20)])
        let result: Geometry<XYZ>? = try unitPoly.intersection(with: lineXYZ)
        XCTAssertNotNil(result)
        if case let .lineString(lineString) = result {
            XCTAssertEqual(lineString.coordinates.count, 2)
        }
    }

    // MARK: - XY ∩ XYM → XYM

    func testIntersectionXYWithXYM() throws {
        let lineXYM = try! LineString(coordinates: [
            XYM(-1, 2, 100),
            XYM(2, -1, 200)])
        let result: Geometry<XYM>? = try unitPoly.intersection(with: lineXYM)
        XCTAssertNotNil(result)
        if case let .lineString(lineString) = result {
            XCTAssertEqual(lineString.coordinates.count, 2)
        }
    }

    // MARK: - XY ∩ XYZM → XYZM

    func testIntersectionXYWithXYZM() throws {
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
