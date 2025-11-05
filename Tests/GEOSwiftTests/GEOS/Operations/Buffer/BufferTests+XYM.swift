import XCTest
import GEOSwift

final class BufferTests_XYM: XCTestCase {
    // Convert XYZM fixtures to XYM using copy constructors
    let point1 = Point<XYM>(Fixtures.point1)
    let polygonWithoutHole = Polygon<XYM>(Fixtures.polygonWithoutHole)

    // Geometry convertibles array needs to be converted element-by-element
    lazy var geometryConvertibles: [any GeometryConvertible<XYM>] = [
        point1,
        Geometry.point(point1),
        MultiPoint<XYM>(Fixtures.multiPoint),
        Geometry.multiPoint(MultiPoint<XYM>(Fixtures.multiPoint)),
        LineString<XYM>(Fixtures.lineString1),
        Geometry.lineString(LineString<XYM>(Fixtures.lineString1)),
        MultiLineString<XYM>(Fixtures.multiLineString),
        Geometry.multiLineString(MultiLineString<XYM>(Fixtures.multiLineString)),
        Polygon<XYM>.LinearRing(Fixtures.linearRingHole1),
        Polygon<XYM>(Fixtures.polygonWithHole),
        Geometry.polygon(Polygon<XYM>(Fixtures.polygonWithHole)),
        MultiPolygon<XYM>(Fixtures.multiPolygon),
        Geometry.multiPolygon(MultiPolygon<XYM>(Fixtures.multiPolygon)),
        GeometryCollection<XYM>(Fixtures.geometryCollection),
        GeometryCollection<XYM>(Fixtures.recursiveGeometryCollection),
        Geometry.geometryCollection(GeometryCollection<XYM>(Fixtures.geometryCollection))
    ]

    func testBufferAllTypes() {
        for geometry in geometryConvertibles {
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

        let actualGeometry = try polygonWithoutHole.buffer(by: -1)

        // Polygonize produces XY geometry and topological equivalence just checks XY geometry
        try XCTAssertTrue(actualGeometry?.isTopologicallyEquivalent(to: expectedGeometry) ?? false)
    }

    func testNegativeBufferWidthWithNilResult() throws {
        try XCTAssertNil(point1.buffer(by: -1))
    }

    func testBufferWithStyleAllTypes() {
        for geometry in geometryConvertibles {
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

        let actualGeometry = try polygonWithoutHole.bufferWithStyle(width: -1)

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
        try XCTAssertNil(point1.bufferWithStyle(width: -1))
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
