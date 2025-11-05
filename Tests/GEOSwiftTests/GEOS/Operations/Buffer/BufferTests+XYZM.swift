import XCTest
import GEOSwift

// MARK: - Test Value Extensions for XYZM

private extension Point where C == XYZM {
    static let testValue1 = Point(XYZM(1, 2, 0, 0))
}

private extension Polygon.LinearRing where C == XYZM {
    // counterclockwise
    static let testValueExterior7 = try! Polygon.LinearRing(coordinates: [
        XYZM(7, 2, 0, 0),
        XYZM(3, 2, 0, 0),
        XYZM(3, -2, 0, 0),
        XYZM(7, -2, 0, 0),
        XYZM(7, 2, 1, 1)])
}

private extension Polygon where C == XYZM {
    static let testValueWithoutHole = Polygon(
        exterior: Polygon<XYZM>.LinearRing.testValueExterior7)
}

final class BufferTests_XYZM: XCTestCase {
    func testBufferAllTypes() {
        for geometry in GEOSTestFixtures_XYZM.geometryConvertibles {
            do {
                _ = try geometry.buffer(by: 0.5)
            } catch {
                XCTFail("Unexpected error for \(geometry) buffer(by: 0.5) \(error)")
            }
        }
    }

    func testNegativeBufferWidthWithNonNilResult() throws {
        let expectedGeometry = try Geometry.polygon(Polygon(
            exterior: Polygon.LinearRing(coordinates: [
                XYZM(6, 1, 0, 0),
                XYZM(4, 1, 1, 1),
                XYZM(4, -1, 2, 2),
                XYZM(6, -1, 3, 3),
                XYZM(6, 1, 0, 0)])))

        let actualGeometry = try Polygon<XYZM>.testValueWithoutHole.buffer(by: -1)

        // Polygonize produces XY geometry and topological equivalence just checks XY geometry
        try XCTAssertTrue(actualGeometry?.isTopologicallyEquivalent(to: expectedGeometry) ?? false)
    }

    func testNegativeBufferWidthWithNilResult() throws {
        try XCTAssertNil(Point<XYZM>.testValue1.buffer(by: -1))
    }

    func testBufferWithStyleAllTypes() {
        for geometry in GEOSTestFixtures_XYZM.geometryConvertibles {
            do {
                _ = try geometry.bufferWithStyle(width: 0.5)
            } catch {
                XCTFail("Unexpected error for \(geometry) bufferWithStyle(width: 0.5) \(error)")
            }
        }
    }

    func testNegativeBufferWithStyleWidthWithNonNilResult() throws {
        let expectedGeometry = try Geometry.polygon(Polygon(
            exterior: Polygon.LinearRing(coordinates: [
                XYZM(6, 1, 0, 0),
                XYZM(4, 1, 1, 1),
                XYZM(4, -1, 2, 2),
                XYZM(6, -1, 3, 3),
                XYZM(6, 1, 0, 0)])))

        let actualGeometry = try Polygon<XY>.testValueWithoutHole.bufferWithStyle(width: -1)

        // Topological equivalence only checks XY
        try XCTAssertTrue(actualGeometry?.isTopologicallyEquivalent(to: expectedGeometry) ?? false)
    }

    func testBufferWithStyleWithFlatEndCap() throws {
        let lineString = try LineString(coordinates: [
            XYZM(0, 0, 0, 0),
            XYZM(1, 0, 0, 1)])

        let expectedGeometry = try Geometry.polygon(Polygon(
            exterior: Polygon.LinearRing(coordinates: [
                XYZM(1, 1, 0, 0),
                XYZM(1, -1, 1, 1),
                XYZM(0, -1, 2, 2),
                XYZM(0, 1, 3, 3),
                XYZM(1, 1, 0, 0)])))

        let actualGeometry = try lineString.bufferWithStyle(width: 1, endCapStyle: .flat)

        try XCTAssertTrue(actualGeometry?.isTopologicallyEquivalent(to: expectedGeometry) ?? false)
    }

    func testBufferWithStyleNegativeBufferWidthWithNilResult() throws {
        try XCTAssertNil(Point<XYZM>.testValue1.bufferWithStyle(width: -1))
    }

    func testOffsetCurve() throws {
        let lineString = try LineString(coordinates: [
            XYZM(0, 0, 0, 0),
            XYZM(10, 0, 1, 1),
            XYZM(10, 10, 0, 2)])

        let expextedLineString = try LineString(coordinates: [
            XY(0, 5),
            XY(5, 5),
            XY(5, 10)])

        let actualGeometry = try lineString.offsetCurve(width: 5, joinStyle: .bevel)

        let expected = Geometry.lineString(expextedLineString)

        // Offset curve produces XY geometry
        XCTAssertEqual(actualGeometry, expected)
    }

    func testOffsetCurveWithNegativeWidth() throws {
        let lineString = try LineString(coordinates: [
            XYZM(0, 0, 0, 0),
            XYZM(10, 0, 1, 1),
            XYZM(10, 10, 0, 2)])

        let expextedLineString = try LineString(coordinates: [
            XY(0, -5),
            XY(10, -5),
            XY(15, 0),
            XY(15, 10)])

        let actualGeometry = try lineString.offsetCurve(width: -5, joinStyle: .bevel)

        // Offset curve produces XY geometry
        XCTAssertTrue(try actualGeometry?.isTopologicallyEquivalent(to: expextedLineString) == true)
    }

}
