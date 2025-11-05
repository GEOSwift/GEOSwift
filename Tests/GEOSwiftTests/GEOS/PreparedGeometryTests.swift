//
//  File.swift
//  
//
//  Created by Andrew Hershberger on 4/22/23.
//

import XCTest
import GEOSwift

final class PreparedGeometryTests: GEOSTestCase_XY {

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
