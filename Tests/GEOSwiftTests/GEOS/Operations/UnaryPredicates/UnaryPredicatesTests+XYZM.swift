import XCTest
import GEOSwift

final class UnaryPredicatesTests_XYZM: XCTestCase {
    // Use XYZM fixtures directly
    let linearRingHole1 = Fixtures.linearRingHole1

    // Geometry convertibles can be used directly from Fixtures
    let geometryConvertibles: [any GeometryConvertible<XYZM>] = Fixtures.allGeometryConvertibles

    // MARK: - Unary Predicates

    func testIsEmpty() {
        var collection = GeometryCollection<XYZM>(geometries: [])

        XCTAssertTrue(try collection.isEmpty())

        collection.geometries += [Geometry.point(Point(XYZM(1, 2, 0, 0)))]

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
        var lineString = LineString(linearRingHole1)

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
