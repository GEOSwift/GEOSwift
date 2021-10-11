import XCTest
import GEOSwift

final class LineStringConvertible_GEOSTests: XCTestCase {

    func testDistanceFromStartToProjectionOfPoint_LineString() {
        let lineString = try! LineString(points: [
            Point(x: 0, y: 0),
            Point(x: 1, y: 0),
            Point(x: 10, y: 0),
            Point(x: 10, y: -10)])

        var point = Point(x: 0, y: 0)
        XCTAssertEqual(try? lineString.distanceFromStart(toProjectionOf: point), 0)

        point.x = -1
        XCTAssertEqual(try? lineString.distanceFromStart(toProjectionOf: point), 0)

        point.x = 1
        XCTAssertEqual(try? lineString.distanceFromStart(toProjectionOf: point), 1)

        point.x = 5
        XCTAssertEqual(try? lineString.distanceFromStart(toProjectionOf: point), 5)

        point.x = 11
        point.y = 1
        XCTAssertEqual(try? lineString.distanceFromStart(toProjectionOf: point), 10)

        point.x = 11
        point.y = -5
        XCTAssertEqual(try? lineString.distanceFromStart(toProjectionOf: point), 15)

        point.x = 5
        point.y = -5
        XCTAssertEqual(try? lineString.distanceFromStart(toProjectionOf: point), 5)
    }

    func testDistanceFromStartToProjectionOfPoint_LinearRing() {
        let linearRing = try! Polygon.LinearRing(points: [
            Point(x: 1, y: 1),
            Point(x: 1, y: -1),
            Point(x: -1, y: -1),
            Point(x: -1, y: 1),
            Point(x: 1, y: 1)])

        var point = Point(x: 2, y: 2)
        XCTAssertEqual(try? linearRing.distanceFromStart(toProjectionOf: point), 0)

        point.x = -2
        point.y = -2
        XCTAssertEqual(try? linearRing.distanceFromStart(toProjectionOf: point), 4)

        point.x = 0.5
        point.y = 0.5
        XCTAssertEqual(try? linearRing.distanceFromStart(toProjectionOf: point), 0.5)

        point.x = 0.5
        point.y = 0.6
        XCTAssertEqual(try? linearRing.distanceFromStart(toProjectionOf: point), 7.5)

        point.x = 0
        point.y = 0
        XCTAssertEqual(try? linearRing.distanceFromStart(toProjectionOf: point), 1)
    }

    func testNormalizedDistanceFromStartToProjectionOfPoint() {
        let lineString = try! LineString(points: [
            Point(x: 0, y: 0),
            Point(x: 1, y: 0),
            Point(x: 10, y: 0),
            Point(x: 10, y: -10)])

        var point = Point(x: 0, y: 0)
        XCTAssertEqual(try? lineString.normalizedDistanceFromStart(toProjectionOf: point), 0)

        point.x = -1
        XCTAssertEqual(try? lineString.normalizedDistanceFromStart(toProjectionOf: point), 0)

        point.x = 1
        XCTAssertEqual(try? lineString.normalizedDistanceFromStart(toProjectionOf: point), 0.05)

        point.x = 5
        XCTAssertEqual(try? lineString.normalizedDistanceFromStart(toProjectionOf: point), 0.25)

        point.x = 11
        point.y = 1
        XCTAssertEqual(try? lineString.normalizedDistanceFromStart(toProjectionOf: point), 0.5)

        point.x = 11
        point.y = -5
        XCTAssertEqual(try? lineString.normalizedDistanceFromStart(toProjectionOf: point), 0.75)

        point.x = 5
        point.y = -5
        XCTAssertEqual(try? lineString.normalizedDistanceFromStart(toProjectionOf: point), 0.25)
    }

    func testNormalizedDistanceFromStartToProjectionOfPoint_LinearRing() {
        let linearRing = try! Polygon.LinearRing(points: [
            Point(x: 1, y: 1),
            Point(x: 1, y: -1),
            Point(x: -1, y: -1),
            Point(x: -1, y: 1),
            Point(x: 1, y: 1)])

        var point = Point(x: 2, y: 2)
        XCTAssertEqual(try? linearRing.normalizedDistanceFromStart(toProjectionOf: point), 0)

        point.x = -2
        point.y = -2
        XCTAssertEqual(try? linearRing.normalizedDistanceFromStart(toProjectionOf: point), 0.5)

        point.x = 0.5
        point.y = 0.5
        XCTAssertEqual(try? linearRing.normalizedDistanceFromStart(toProjectionOf: point), 0.5 / 8)

        point.x = 0.5
        point.y = 0.6
        XCTAssertEqual(try? linearRing.normalizedDistanceFromStart(toProjectionOf: point), 7.5 / 8)

        point.x = 0
        point.y = 0
        XCTAssertEqual(try? linearRing.normalizedDistanceFromStart(toProjectionOf: point), 1 / 8)
    }

    func testNormalizedDistanceFromStartToProjectionOfPointLineLengthZero_LineString() {
        let lineString = try! LineString(points: Array(repeating: Point(x: 0, y: 0), count: 2))

        let point = Point(x: 0, y: 0)

        do {
            _ = try lineString.normalizedDistanceFromStart(toProjectionOf: point)
            XCTFail("Expected call to throw, but it did not.")
        } catch GEOSwiftError.lengthIsZero {
            // Pass
        } catch {
            XCTFail("Threw unexpected error: \(error)")
        }
    }

    func testNormalizedDistanceFromStartToProjectionOfPointLineLengthZero_LinearRing() {
        let linearRing = try! Polygon.LinearRing(points: Array(repeating: Point(x: 0, y: 0), count: 4))

        let point = Point(x: 0, y: 0)

        do {
            _ = try linearRing.normalizedDistanceFromStart(toProjectionOf: point)
            XCTFail("Expected call to throw, but it did not.")
        } catch GEOSwiftError.lengthIsZero {
            // Pass
        } catch {
            XCTFail("Threw unexpected error: \(error)")
        }
    }

    func testInterpolatedPointWithDistance_LineString() {
        let lineString = try! LineString(points: [
            Point(x: 0, y: 0),
            Point(x: 10, y: 0)])

        XCTAssertEqual(try! lineString.interpolatedPoint(withDistance: 5), Point(x: 5, y: 0))
        XCTAssertEqual(try! lineString.interpolatedPoint(withDistance: -1), Point(x: 9, y: 0))
        XCTAssertEqual(try! lineString.interpolatedPoint(withDistance: 11), Point(x: 10, y: 0))
    }

    func testInterpolatedPointWithDistance_LinearRing() {
        let linearRing = try! Polygon.LinearRing(points: [
            Point(x: 1, y: 1),
            Point(x: 1, y: -1),
            Point(x: -1, y: -1),
            Point(x: -1, y: 1),
            Point(x: 1, y: 1)])

        XCTAssertEqual(try! linearRing.interpolatedPoint(withDistance: 5), Point(x: -1, y: 0))
        XCTAssertEqual(try! linearRing.interpolatedPoint(withDistance: -1), Point(x: 0, y: 1))
        XCTAssertEqual(try! linearRing.interpolatedPoint(withDistance: 11), Point(x: 1, y: 1))
    }

    func testInterpolatedPointWithFraction_LineString() {
        let lineString = try! LineString(points: [
            Point(x: 0, y: 0),
            Point(x: 10, y: 0)])

        XCTAssertEqual(try! lineString.interpolatedPoint(withFraction: 0.5), Point(x: 5, y: 0))
        XCTAssertEqual(try! lineString.interpolatedPoint(withFraction: -0.1), Point(x: 9, y: 0))
        XCTAssertEqual(try! lineString.interpolatedPoint(withFraction: 1.1), Point(x: 10, y: 0))
    }

    func testInterpolatedPointWithFraction_LinearRing() {
        let linearRing = try! Polygon.LinearRing(points: [
            Point(x: 1, y: 1),
            Point(x: 1, y: -1),
            Point(x: -1, y: -1),
            Point(x: -1, y: 1),
            Point(x: 1, y: 1)])

        XCTAssertEqual(try! linearRing.interpolatedPoint(withFraction: 0.625), Point(x: -1, y: 0))
        XCTAssertEqual(try! linearRing.interpolatedPoint(withFraction: -0.125), Point(x: 0, y: 1))
        XCTAssertEqual(try! linearRing.interpolatedPoint(withFraction: 1.375), Point(x: 1, y: 1))
    }
}
