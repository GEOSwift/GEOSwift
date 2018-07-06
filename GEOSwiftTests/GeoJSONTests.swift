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
            guard case .some(.some) = try? Features.fromGeoJSON(geoJSONURL) else {
                XCTFail("Can't extract geometry from GeoJSON: \(geoJSONURL.lastPathComponent)")
                continue
            }
        }
    }

    func testGeoJSONFromData() {
        let bundle = Bundle(for: GEOSwiftTests.self)
        guard let geojsons = bundle.urls(forResourcesWithExtension: "geojson", subdirectory: nil) else {
            XCTFail("Could not load geojson files")
            return
        }
        for geoJSONURL in geojsons {
            guard let data = try? Data(contentsOf: geoJSONURL),
                case .some(.some) = try? Features.fromGeoJSON(data) else {
                    XCTFail("Can't extract geometry from GeoJSON data from: \(geoJSONURL.lastPathComponent)")
                    continue
            }
        }
    }

    func testGeoJSONFromString() {
        let bundle = Bundle(for: GEOSwiftTests.self)
        guard let geojsons = bundle.urls(forResourcesWithExtension: "geojson", subdirectory: nil) else {
            XCTFail("Could not load geojson files")
            return
        }
        for geoJSONURL in geojsons {
            guard let string = try? String(contentsOf: geoJSONURL),
                case .some(.some) = try? Features.fromGeoJSON(string) else {
                    XCTFail("Can't extract geometry from GeoJSON string from: \(geoJSONURL.lastPathComponent)")
                    continue
            }
        }
    }

}
