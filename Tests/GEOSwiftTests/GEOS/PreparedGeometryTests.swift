//
//  File.swift
//  
//
//  Created by Andrew Hershberger on 4/22/23.
//

import XCTest
import GEOSwift

final class PreparedGeometryTests: XCTestCase {

    let geometryConvertibles: [GeometryConvertible] = [
        Point.testValue1,
        Geometry.point(.testValue1),
        MultiPoint.testValue,
        Geometry.multiPoint(.testValue),
        LineString.testValue1,
        Geometry.lineString(.testValue1),
        MultiLineString.testValue,
        Geometry.multiLineString(.testValue),
        Polygon.LinearRing.testValueHole1,
        Polygon.testValueWithHole,
        Geometry.polygon(.testValueWithHole),
        MultiPolygon.testValue,
        Geometry.multiPolygon(.testValue),
        GeometryCollection.testValue,
        GeometryCollection.testValueWithRecursion,
        Geometry.geometryCollection(.testValue)]

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
