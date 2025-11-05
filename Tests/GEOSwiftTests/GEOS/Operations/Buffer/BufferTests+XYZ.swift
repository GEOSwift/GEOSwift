import XCTest
import GEOSwift

final class BufferTests_XYZ: XCTestCase {
    // Convert XYZM fixtures to XYZ using copy constructors
    let point1 = Point<XYZ>(Fixtures.point1)
    let polygonWithoutHole = Polygon<XYZ>(Fixtures.polygonWithoutHole)

    // Geometry convertibles array needs to be converted element-by-element
    lazy var geometryConvertibles: [any GeometryConvertible<XYZ>] = [
        point1,
        Geometry.point(point1),
        MultiPoint<XYZ>(Fixtures.multiPoint),
        Geometry.multiPoint(MultiPoint<XYZ>(Fixtures.multiPoint)),
        LineString<XYZ>(Fixtures.lineString1),
        Geometry.lineString(LineString<XYZ>(Fixtures.lineString1)),
        MultiLineString<XYZ>(Fixtures.multiLineString),
        Geometry.multiLineString(MultiLineString<XYZ>(Fixtures.multiLineString)),
        Polygon<XYZ>.LinearRing(Fixtures.linearRingHole1),
        Polygon<XYZ>(Fixtures.polygonWithHole),
        Geometry.polygon(Polygon<XYZ>(Fixtures.polygonWithHole)),
        MultiPolygon<XYZ>(Fixtures.multiPolygon),
        Geometry.multiPolygon(MultiPolygon<XYZ>(Fixtures.multiPolygon)),
        GeometryCollection<XYZ>(Fixtures.geometryCollection),
        GeometryCollection<XYZ>(Fixtures.recursiveGeometryCollection),
        Geometry.geometryCollection(GeometryCollection<XYZ>(Fixtures.geometryCollection))
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
                XYZ(6, 1, 0),
                XYZ(4, 1, 1),
                XYZ(4, -1, 2),
                XYZ(6, -1, 3),
                XYZ(6, 1, 0)])))

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
                XYZ(6, 1, 0),
                XYZ(4, 1, 1),
                XYZ(4, -1, 2),
                XYZ(6, -1, 3),
                XYZ(6, 1, 0)])))

        let actualGeometry = try polygonWithoutHole.bufferWithStyle(width: -1)

        // Topological equivalence only checks XY
        try XCTAssertTrue(actualGeometry?.isTopologicallyEquivalent(to: expectedGeometry) ?? false)
    }

    func testBufferWithStyleWithFlatEndCap() throws {
        let lineString = try LineString(coordinates: [
            XYZ(0, 0, 0),
            XYZ(1, 0, 0)])

        let expectedGeometry = try Geometry.polygon(Polygon(
            exterior: Polygon.LinearRing(coordinates: [
                XYZ(1, 1, 0),
                XYZ(1, -1, 1),
                XYZ(0, -1, 2),
                XYZ(0, 1, 3),
                XYZ(1, 1, 0)])))

        let actualGeometry = try lineString.bufferWithStyle(width: 1, endCapStyle: .flat)

        try XCTAssertTrue(actualGeometry?.isTopologicallyEquivalent(to: expectedGeometry) ?? false)
    }

    func testBufferWithStyleNegativeBufferWidthWithNilResult() throws {
        try XCTAssertNil(point1.bufferWithStyle(width: -1))
    }

    func testOffsetCurve() throws {
        let lineString = try LineString(coordinates: [
            XYZ(0, 0, 0),
            XYZ(10, 0, 1),
            XYZ(10, 10, 0)])

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
            XYZ(0, 0, 0),
            XYZ(10, 0, 1),
            XYZ(10, 10, 0)])

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
