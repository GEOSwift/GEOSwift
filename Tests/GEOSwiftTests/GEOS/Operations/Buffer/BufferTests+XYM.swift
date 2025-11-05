import XCTest
import GEOSwift

// MARK: - Test Value Extensions for XYM

private extension Point where C == XYM {
    static let testValue1 = Point(XYM(1, 2, 0))
}

private extension Polygon.LinearRing where C == XYM {
    // counterclockwise
    static let testValueExterior7 = try! Polygon.LinearRing(coordinates: [
        XYM(7, 2, 0),
        XYM(3, 2, 0),
        XYM(3, -2, 0),
        XYM(7, -2, 0),
        XYM(7, 2, 1)])
}

private extension Polygon where C == XYM {
    static let testValueWithoutHole = Polygon(
        exterior: Polygon<XYM>.LinearRing.testValueExterior7)
}

final class BufferTests_XYM: XCTestCase {
    func testBufferAllTypes() {
        for geometry in GEOSTestFixtures_XYM.geometryConvertibles {
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
                XYM(6, 1, 0),
                XYM(4, 1, 1),
                XYM(4, -1, 2),
                XYM(6, -1, 3),
                XYM(6, 1, 0)])))

        let actualGeometry = try Polygon<XYM>.testValueWithoutHole.buffer(by: -1)

        // Polygonize produces XY geometry and topological equivalence just checks XY geometry
        try XCTAssertTrue(actualGeometry?.isTopologicallyEquivalent(to: expectedGeometry) ?? false)
    }

    func testNegativeBufferWidthWithNilResult() throws {
        try XCTAssertNil(Point<XYM>.testValue1.buffer(by: -1))
    }

    func testBufferWithStyleAllTypes() {
        for geometry in GEOSTestFixtures_XYM.geometryConvertibles {
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
                XYM(6, 1, 0),
                XYM(4, 1, 1),
                XYM(4, -1, 2),
                XYM(6, -1, 3),
                XYM(6, 1, 0)])))

        let actualGeometry = try Polygon<XY>.testValueWithoutHole.bufferWithStyle(width: -1)

        // Topological equivalence only checks XY
        try XCTAssertTrue(actualGeometry?.isTopologicallyEquivalent(to: expectedGeometry) ?? false)
    }

    func testBufferWithStyleWithFlatEndCap() throws {
        let lineString = try LineString(coordinates: [
            XYM(0, 0, 0),
            XYM(1, 0, 1)])

        let expectedGeometry = try Geometry.polygon(Polygon(
            exterior: Polygon.LinearRing(coordinates: [
                XYM(1, 1, 0),
                XYM(1, -1, 1),
                XYM(0, -1, 2),
                XYM(0, 1, 3),
                XYM(1, 1, 0)])))

        let actualGeometry = try lineString.bufferWithStyle(width: 1, endCapStyle: .flat)

        try XCTAssertTrue(actualGeometry?.isTopologicallyEquivalent(to: expectedGeometry) ?? false)
    }

    func testBufferWithStyleNegativeBufferWidthWithNilResult() throws {
        try XCTAssertNil(Point<XYM>.testValue1.bufferWithStyle(width: -1))
    }

    func testOffsetCurve() throws {
        let lineString = try LineString(coordinates: [
            XYM(0, 0, 0),
            XYM(10, 0, 1),
            XYM(10, 10, 2)])

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
            XYM(0, 0, 0),
            XYM(10, 0, 1),
            XYM(10, 10, 2)])

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
