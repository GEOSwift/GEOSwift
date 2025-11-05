import XCTest
import GEOSwift

final class BufferTests: XCTestCase {
    func testBufferAllTypes() {
        for geometry in GEOSTestFixtures.geometryConvertibles {
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
                XY(6, 1),
                XY(4, 1),
                XY(4, -1),
                XY(6, -1),
                XY(6, 1)])))

        let actualGeometry = try Polygon.testValueWithoutHole.buffer(by: -1)

        try XCTAssertTrue(actualGeometry?.isTopologicallyEquivalent(to: expectedGeometry) ?? false)
    }

    func testNegativeBufferWidthWithNilResult() throws {
        try XCTAssertNil(Point.testValue1.buffer(by: -1))
    }

    func testBufferWithStyleAllTypes() {
        for geometry in GEOSTestFixtures.geometryConvertibles {
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
                XY(6, 1),
                XY(4, 1),
                XY(4, -1),
                XY(6, -1),
                XY(6, 1)])))

        let actualGeometry = try Polygon.testValueWithoutHole.bufferWithStyle(width: -1)

        try XCTAssertTrue(actualGeometry?.isTopologicallyEquivalent(to: expectedGeometry) ?? false)
    }

    func testBufferWithStyleWithFlatEndCap() throws {
        let lineString = try LineString(coordinates: [
            XY(0, 0),
            XY(1, 0)])

        let expectedGeometry = try Geometry.polygon(Polygon(
            exterior: Polygon.LinearRing(coordinates: [
                XY(1, 1),
                XY(1, -1),
                XY(0, -1),
                XY(0, 1),
                XY(1, 1)])))

        let actualGeometry = try lineString.bufferWithStyle(width: 1, endCapStyle: .flat)

        try XCTAssertTrue(actualGeometry?.isTopologicallyEquivalent(to: expectedGeometry) ?? false)
    }

    func testBufferWithStyleNegativeBufferWidthWithNilResult() throws {
        try XCTAssertNil(Point.testValue1.bufferWithStyle(width: -1))
    }

    func testOffsetCurve() throws {
        let lineString = try LineString(coordinates: [
            XY(0, 0),
            XY(10, 0),
            XY(10, 10)])

        let expextedLineString = try LineString(coordinates: [
            XY(0, 5),
            XY(5, 5),
            XY(5, 10)])

        let actualGeometry = try lineString.offsetCurve(width: 5, joinStyle: .bevel)

        XCTAssertEqual(actualGeometry, .lineString(expextedLineString))
    }

    func testOffsetCurveWithNegativeWidth() throws {
        let lineString = try LineString(coordinates: [
            XY(0, 0),
            XY(10, 0),
            XY(10, 10)])

        let expextedLineString = try LineString(coordinates: [
            XY(0, -5),
            XY(10, -5),
            XY(15, 0),
            XY(15, 10)])

        let actualGeometry = try lineString.offsetCurve(width: -5, joinStyle: .bevel)
        XCTAssertTrue(try actualGeometry?.isTopologicallyEquivalent(to: expextedLineString) == true)
    }

}
