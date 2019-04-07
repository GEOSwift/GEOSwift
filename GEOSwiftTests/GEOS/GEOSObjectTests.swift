import XCTest
import geos
@testable import GEOSwift

final class GEOSObjectTests: GEOSContextTestCase {
    func testInitWithContext() {
        let point = GEOSGeom_createEmptyPoint_r(context.handle)!

        let object = GEOSObject(context: context, pointer: point)

        XCTAssertTrue(object.context === context)
        XCTAssertEqual(object.pointer, point)
        XCTAssertNil(object.parent)
    }

    func testInitWithParent() {
        let point1 = try! Point(x: 10, y: 10).geosObject(with: context)
        let point2 = try! Point(x: 20, y: 20).geosObject(with: context)
        let points = [point1, point2]
        let geometriesPointer = UnsafeMutablePointer<OpaquePointer?>.allocate(capacity: points.count)
        defer { geometriesPointer.deallocate() }
        points.enumerated().forEach { (i, point) in
            geometriesPointer[i] = point.pointer
        }
        let collection = GEOSGeom_createCollection_r(
            context.handle,
            Int32(GEOS_MULTIPOINT.rawValue),
            geometriesPointer,
            UInt32(points.count))!
        let collectionObject = GEOSObject(context: context, pointer: collection)
        point1.parent = collectionObject
        point2.parent = collectionObject
        let point = GEOSGetGeometryN_r(collectionObject.context.handle, collectionObject.pointer, 1)!

        let object = GEOSObject(parent: collectionObject, pointer: point)

        XCTAssertTrue(object.context === context)
        XCTAssertEqual(object.pointer, point)
        XCTAssertTrue(object.parent === collectionObject)
    }

    func testTypePoint() {
        XCTAssertEqual(try? Point.testValue1.geosObject(with: context).type, .point)
    }

    func testTypeLineString() {
        XCTAssertEqual(try? LineString.testValue1.geosObject(with: context).type, .lineString)
    }

    func testTypeLinearRing() {
        XCTAssertEqual(try? Polygon.LinearRing.testValueHole1.geosObject(with: context).type, .linearRing)
    }

    func testTypePolygon() {
        XCTAssertEqual(try? Polygon.testValueWithHole.geosObject(with: context).type, .polygon)
    }

    func testTypeMultiPoint() {
        XCTAssertEqual(try? MultiPoint.testValue.geosObject(with: context).type, .multiPoint)
    }

    func testTypeMultiLineString() {
        XCTAssertEqual(try? MultiLineString.testValue.geosObject(with: context).type, .multiLineString)
    }

    func testTypeMultiPolygon() {
        XCTAssertEqual(try? MultiPolygon.testValue.geosObject(with: context).type, .multiPolygon)
    }

    func testTypeGeometryCollection() {
        XCTAssertEqual(try? GeometryCollection.testValue.geosObject(with: context).type, .geometryCollection)
    }
}
