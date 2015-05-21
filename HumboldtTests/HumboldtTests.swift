//
//  HumboldtTests.swift
//  geosswifttest2
//
//  Created by Andrea Cremaschi on 21/05/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

import UIKit
import XCTest
import HumboldtDemo

class HumboldtTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCreatePointFromWKT() {
        // This is an example of a functional test case.
        let geom = Geometry(WKT: "POINT(45 9)")
        XCTAssertNotNil(geom, "Geometry is nil")
        XCTAssert(geom?.points[0].x == 45 && geom?.points[0].y == 9 , "Geometry is not a point or it has not been correctly valorized")
    }

    func testCreateLinestringFromWKT() {
        // This is an example of a functional test case.
        let geom = Geometry(WKT: "LINESTRING(3 4,10 50,20 25)")
        XCTAssertNotNil(geom, "Geometry is nil")
        XCTAssert(geom?.points.count() == 3 && geom?.points[0].x == 3 && geom?.points[0].y == 4 , "Geometry is not a point or it has not been correctly valorized")
    }

    func testCreatePolygonFromWKT() {
        // This is an example of a functional test case.
        let geom = Geometry(WKT: "POLYGON((1 1,5 1,5 5,1 5,1 1),(2 2, 3 2, 3 3, 2 3,2 2))")
        XCTAssertNotNil(geom, "Geometry is nil")
        XCTAssert(geom?.points.count() == 3 && geom?.points[0].x == 3 && geom?.points[0].y == 4 , "Geometry is not a point or it has not been correctly valorized")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
