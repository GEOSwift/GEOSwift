//
//  File.swift
//  
//
//  Created by Andrew Hershberger on 4/22/23.
//

import XCTest
import GEOSwift

final class PreparedGeometryTests: XCTestCase {
    // Convert XYZM fixtures to XY using copy constructors
    let point1 = Point<XY>(Fixtures.point1)
    let multiPoint = MultiPoint<XY>(Fixtures.multiPoint)
    let lineString1 = LineString<XY>(Fixtures.lineString1)
    let multiLineString = MultiLineString<XY>(Fixtures.multiLineString)
    let linearRingHole1 = Polygon<XY>.LinearRing(Fixtures.linearRingHole1)
    let polygonWithHole = Polygon<XY>(Fixtures.polygonWithHole)
    let multiPolygon = MultiPolygon<XY>(Fixtures.multiPolygon)
    let geometryCollection = GeometryCollection<XY>(Fixtures.geometryCollection)

    lazy var geometryConvertibles: [any GeometryConvertible<XY>] = [
        point1,
        Geometry.point(point1),
        multiPoint,
        Geometry.multiPoint(multiPoint),
        lineString1,
        Geometry.lineString(lineString1),
        multiLineString,
        Geometry.multiLineString(multiLineString),
        linearRingHole1,
        polygonWithHole,
        Geometry.polygon(polygonWithHole),
        multiPolygon,
        Geometry.multiPolygon(multiPolygon),
        geometryCollection,
        GeometryCollection<XY>(Fixtures.recursiveGeometryCollection),
        Geometry.geometryCollection(geometryCollection)
    ]

    func testContainsAllTypes() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.makePrepared().contains(g2)
            } catch {
                XCTFail("Unexpected error for \(g1) makePrepared().contains( \(g2)) \(error)")
            }
        }
    }

    func testContainsProperlyAllTypes() {
        for (g1, g2) in geometryConvertibles.allPairs {
            do {
                _ = try g1.makePrepared().containsProperly(g2)
            } catch {
                XCTFail("Unexpected error for \(g1) makePrepared().containsProperly( \(g2)) \(error)")
            }
        }
    }
}
