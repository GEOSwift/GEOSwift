import XCTest
import GEOSwift

final class UnaryPredicatesTests: GEOSTestCase_XY {

    // MARK: - Unary Predicates

    func testIsEmpty() {
        var collection = GeometryCollection<XY>(geometries: [])

        XCTAssertTrue(try collection.isEmpty())

        collection.geometries += [Geometry.point(Point(x: 1, y: 2))]

        XCTAssertFalse(try collection.isEmpty())
    }

    func testIsEmptyAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.isEmpty()
            } catch {
                XCTFail("Unexpected error for \(g) isEmpty() \(error)")
            }
        }
    }

    func testIsRing() {
        var lineString = LineString(linearRingLength4)

        XCTAssertTrue(try lineString.isRing())

        lineString = try! LineString(coordinates: lineString.coordinates.dropLast())

        XCTAssertFalse(try lineString.isRing())
    }

    func testIsRingAllTypes() {
        for g in geometryConvertibles {
            do {
                _ = try g.isRing()
            } catch {
                XCTFail("Unexpected error for \(g) isRing() \(error)")
            }
        }
    }
}
