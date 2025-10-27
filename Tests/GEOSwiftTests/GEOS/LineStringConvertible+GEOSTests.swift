import XCTest
import GEOSwift

final class LineStringConvertible_GEOSTests: XCTestCase {

    func testDistanceFromStartToProjectionOfPoint_LineString() {
        let lineString = try! LineString(coordinates: [
            XY(0, 0),
            XY(1, 0),
            XY(10, 0),
            XY(10, -10)])

        var point = XY(0, 0)
        XCTAssertEqual(try? lineString.distanceFromStart(toProjectionOf: Point(point)), 0)

        point.x = -1
        XCTAssertEqual(try? lineString.distanceFromStart(toProjectionOf: Point(point)), 0)

        point.x = 1
        XCTAssertEqual(try? lineString.distanceFromStart(toProjectionOf: Point(point)), 1)

        point.x = 5
        XCTAssertEqual(try? lineString.distanceFromStart(toProjectionOf: Point(point)), 5)

        point.x = 11
        point.y = 1
        XCTAssertEqual(try? lineString.distanceFromStart(toProjectionOf: Point(point)), 10)

        point.x = 11
        point.y = -5
        XCTAssertEqual(try? lineString.distanceFromStart(toProjectionOf: Point(point)), 15)

        point.x = 5
        point.y = -5
        XCTAssertEqual(try? lineString.distanceFromStart(toProjectionOf: Point(point)), 5)
    }

    func testDistanceFromStartToProjectionOfPoint_LinearRing() {
        let linearRing = try! Polygon.LinearRing(coordinates: [
            XY(1, 1),
            XY(1, -1),
            XY(-1, -1),
            XY(-1, 1),
            XY(1, 1)])

        var point = XY(2, 2)
        XCTAssertEqual(try? linearRing.distanceFromStart(toProjectionOf: Point(point)), 0)

        point.x = -2
        point.y = -2
        XCTAssertEqual(try? linearRing.distanceFromStart(toProjectionOf: Point(point)), 4)

        point.x = 0.5
        point.y = 0.5
        XCTAssertEqual(try? linearRing.distanceFromStart(toProjectionOf: Point(point)), 0.5)

        point.x = 0.5
        point.y = 0.6
        XCTAssertEqual(try? linearRing.distanceFromStart(toProjectionOf: Point(point)), 7.5)

        point.x = 0
        point.y = 0
        XCTAssertEqual(try? linearRing.distanceFromStart(toProjectionOf: Point(point)), 1)
    }

    func testNormalizedDistanceFromStartToProjectionOfPoint() {
        let lineString = try! LineString(coordinates: [
            XY(0, 0),
            XY(1, 0),
            XY(10, 0),
            XY(10, -10)])

        var point = XY(0, 0)
        XCTAssertEqual(try? lineString.normalizedDistanceFromStart(toProjectionOf: Point(point)), 0)

        point.x = -1
        XCTAssertEqual(try? lineString.normalizedDistanceFromStart(toProjectionOf: Point(point)), 0)

        point.x = 1
        XCTAssertEqual(try? lineString.normalizedDistanceFromStart(toProjectionOf: Point(point)), 0.05)

        point.x = 5
        XCTAssertEqual(try? lineString.normalizedDistanceFromStart(toProjectionOf: Point(point)), 0.25)

        point.x = 11
        point.y = 1
        XCTAssertEqual(try? lineString.normalizedDistanceFromStart(toProjectionOf: Point(point)), 0.5)

        point.x = 11
        point.y = -5
        XCTAssertEqual(try? lineString.normalizedDistanceFromStart(toProjectionOf: Point(point)), 0.75)

        point.x = 5
        point.y = -5
        XCTAssertEqual(try? lineString.normalizedDistanceFromStart(toProjectionOf: Point(point)), 0.25)
    }

    func testNormalizedDistanceFromStartToProjectionOfPoint_LinearRing() {
        let linearRing = try! Polygon.LinearRing(coordinates: [
            XY(1, 1),
            XY(1, -1),
            XY(-1, -1),
            XY(-1, 1),
            XY(1, 1)])

        var point = XY(2, 2)
        XCTAssertEqual(try? linearRing.normalizedDistanceFromStart(toProjectionOf: Point(point)), 0)

        point.x = -2
        point.y = -2
        XCTAssertEqual(try? linearRing.normalizedDistanceFromStart(toProjectionOf: Point(point)), 0.5)

        point.x = 0.5
        point.y = 0.5
        XCTAssertEqual(try? linearRing.normalizedDistanceFromStart(toProjectionOf: Point(point)), 0.5 / 8)

        point.x = 0.5
        point.y = 0.6
        XCTAssertEqual(try? linearRing.normalizedDistanceFromStart(toProjectionOf: Point(point)), 7.5 / 8)

        point.x = 0
        point.y = 0
        XCTAssertEqual(try? linearRing.normalizedDistanceFromStart(toProjectionOf: Point(point)), 1 / 8)
    }

    func testNormalizedDistanceFromStartToProjectionOfPointLineLengthZero_LineString() throws {
        let lineString = try! LineString(coordinates: Array(repeating: XY(0, 0), count: 2))

        let point = XY(0, 0)

        XCTAssertEqual(try lineString.normalizedDistanceFromStart(toProjectionOf: Point(point)), 0)
    }

    func testNormalizedDistanceFromStartToProjectionOfPointLineLengthZero_LinearRing() throws {
        let linearRing = try! Polygon.LinearRing(coordinates: Array(repeating: XY(0, 0), count: 4))

        let point = XY(0, 0)

        XCTAssertEqual(try linearRing.normalizedDistanceFromStart(toProjectionOf: Point(point)), 0)
    }

    func testInterpolatedPointWithDistance_LineString() {
        let lineString = try! LineString(coordinates: [
            XY(0, 0),
            XY(10, 0)])

        XCTAssertEqual(try! lineString.interpolatedPoint(withDistance: 5), Point(XY(5, 0)))
        XCTAssertEqual(try! lineString.interpolatedPoint(withDistance: -1), Point(XY(9, 0)))
        XCTAssertEqual(try! lineString.interpolatedPoint(withDistance: 11), Point(XY(10, 0)))
    }

    func testInterpolatedPointWithDistance_LinearRing() {
        let linearRing = try! Polygon.LinearRing(coordinates: [
            XY(1, 1),
            XY(1, -1),
            XY(-1, -1),
            XY(-1, 1),
            XY(1, 1)])

        XCTAssertEqual(try! linearRing.interpolatedPoint(withDistance: 5), Point(XY(-1, 0)))
        XCTAssertEqual(try! linearRing.interpolatedPoint(withDistance: -1), Point(XY(0, 1)))
        XCTAssertEqual(try! linearRing.interpolatedPoint(withDistance: 11), Point(XY(1, 1)))
    }

    func testInterpolatedPointWithFraction_LineString() {
        let lineString = try! LineString(coordinates: [
            XY(0, 0),
            XY(10, 0)])

        XCTAssertEqual(try! lineString.interpolatedPoint(withFraction: 0.5), Point(XY(5, 0)))
        XCTAssertEqual(try! lineString.interpolatedPoint(withFraction: -0.1), Point(XY(9, 0)))
        XCTAssertEqual(try! lineString.interpolatedPoint(withFraction: 1.1), Point(XY(10, 0)))
    }

    func testInterpolatedPointWithFraction_LinearRing() {
        let linearRing = try! Polygon.LinearRing(coordinates: [
            XY(1, 1),
            XY(1, -1),
            XY(-1, -1),
            XY(-1, 1),
            XY(1, 1)])

        XCTAssertEqual(try! linearRing.interpolatedPoint(withFraction: 0.625), Point(XY(-1, 0)))
        XCTAssertEqual(try! linearRing.interpolatedPoint(withFraction: -0.125), Point(XY(0, 1)))
        XCTAssertEqual(try! linearRing.interpolatedPoint(withFraction: 1.375), Point(XY(1, 1)))
    }

    func testSubstring_LineString() throws {
        let lineString = try LineString(coordinates: [
            XY(0, 0),
            XY(10, 0)])

        XCTAssertEqual(try lineString.substring(fromFraction: 0, toFraction: 1).coordinates, [
            XY(0, 0),
            XY(10, 0)])
        XCTAssertEqual(try lineString.substring(fromFraction: 0.625, toFraction: 0.8125).coordinates, [
            XY(6.25, 0),
            XY(8.125, 0)])
        XCTAssertEqual(try lineString.substring(fromFraction: 0.7, toFraction: 1).coordinates, [
            XY(7, 0),
            XY(10, 0)])
    }

    func testSubstring_LinearRing() throws {
        let linearRing = try Polygon.LinearRing(coordinates: [
            XY(1, 1),
            XY(1, -1),
            XY(-1, -1),
            XY(-1, 1),
            XY(1, 1)])

        XCTAssertEqual(try linearRing.substring(fromFraction: 0, toFraction: 1).coordinates, [
            XY(1, 1),
            XY(1, -1),
            XY(-1, -1),
            XY(-1, 1),
            XY(1, 1)])
        XCTAssertEqual(try linearRing.substring(fromFraction: 0.625, toFraction: 0.8125).coordinates, [
            XY(-1, 0),
            XY(-1, 1),
            XY(-0.5, 1)])
        XCTAssertEqual(try linearRing.substring(fromFraction: 0.8125, toFraction: 1).coordinates, [
            XY(-0.5, 1),
            XY(1, 1)])
    }
}
