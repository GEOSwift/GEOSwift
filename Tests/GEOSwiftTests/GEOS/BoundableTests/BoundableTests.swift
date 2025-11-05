import XCTest
import GEOSwift

final class BoundableTests: GEOSTestCase_XY {
    lazy var boundables: [any Boundable<XY>] = [
        point1,
        multiPoint,
        lineString1,
        multiLineString,
        linearRingHole1,
        polygonWithHole,
        multiPolygon]

    func testBoundaryLine() {
        let line = try! LineString(coordinates: [XY(0, 0), XY(1, 0)])

        do {
            let boundary = try line.boundary()
            guard case let .multiPoint(multiPoint) = boundary else {
                XCTFail("Expected multipoint, but got \(boundary)")
                return
            }
            XCTAssertEqual(multiPoint.points.count, 2)
            XCTAssertTrue(multiPoint.points.contains(Point(line.coordinates[0])))
            XCTAssertTrue(multiPoint.points.contains(Point(line.coordinates[1])))
        } catch {
            XCTFail("Unexpected error for \(line) boundary() \(error)")
        }
    }

    func testBoundaryAllTypes() {
        for b in boundables {
            do {
                _ = try b.boundary()
            } catch {
                XCTFail("Unexpected error for \(b) boundary() \(error)")
            }
        }
    }
}
