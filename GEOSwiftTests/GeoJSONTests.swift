//  Copyright © 2017 GEOSwift. All rights reserved.

import Foundation
import XCTest
import GEOSwift

final class GeoJSONTests: XCTestCase {

    func testGeoJSONFromURL() {
        let bundle = Bundle(for: GEOSwiftTests.self)
        guard let geojsons = bundle.urls(forResourcesWithExtension: "geojson", subdirectory: nil) else {
            XCTFail("Could not load geojson files")
            return
        }
        for geoJSONURL in geojsons {
            guard let geometries = try! Features.fromGeoJSON(geoJSONURL) else {
                XCTFail("Can't extract geometry from GeoJSON: \(geoJSONURL.lastPathComponent)")
                continue
            }
//                geometries[0].debugQuickLookObject()
            print("\(geoJSONURL.lastPathComponent): \(geometries)")
        }
    }

    func testGeoJSONFromData() {
        let bundle = Bundle(for: GEOSwiftTests.self)
        guard let geojsons = bundle.urls(forResourcesWithExtension: "geojson", subdirectory: nil) else {
            XCTFail("Could not load geojson files")
            return
        }
        for geoJSONURL in geojsons {
            let data = try! Data(contentsOf: geoJSONURL)
            guard let geometries = try! Features.fromGeoJSON(data) else {
                XCTFail("Can't extract geometry from GeoJSON data from: \(geoJSONURL.lastPathComponent)")
                continue
            }
//                geometries[0].debugQuickLookObject()
            print("\(geoJSONURL.lastPathComponent): \(geometries)")
        }
    }

    func testGeoJSONFromString() {
        let bundle = Bundle(for: GEOSwiftTests.self)
        guard let geojsons = bundle.urls(forResourcesWithExtension: "geojson", subdirectory: nil) else {
            XCTFail("Could not load geojson files")
            return
        }
        for geoJSONURL in geojsons {
            let string = try! String(contentsOf: geoJSONURL)
            guard let geometries = try! Features.fromGeoJSON(string) else {
                XCTFail("Can't extract geometry from GeoJSON string from: \(geoJSONURL.lastPathComponent)")
                continue
            }
//                geometries[0].debugQuickLookObject()
            print("\(geoJSONURL.lastPathComponent): \(geometries)")
        }
    }

}
