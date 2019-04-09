//  Copyright © 2017 GEOSwift. All rights reserved.

import Foundation
import XCTest
import GEOSwift

final class GeoJSONTests: XCTestCase {

    var geoJsonUrls: [URL]!

    override func setUp() {
        super.setUp()
        let bundle = Bundle(for: GeoJSONTests.self)
        guard let urls = bundle.urls(forResourcesWithExtension: "geojson", subdirectory: nil) else {
            XCTFail("Could not load geojson files")
            return
        }
        geoJsonUrls = urls
    }

    func testGeoJSONFromURL() {
        for geoJSONURL in geoJsonUrls {
            guard case .some = try? Features.fromGeoJSON(geoJSONURL) else {
                XCTFail("Can't extract geometry from GeoJSON: \(geoJSONURL.lastPathComponent)")
                continue
            }
        }
    }

    func testGeoJSONFromData() {
        for geoJSONURL in geoJsonUrls {
            guard let data = try? Data(contentsOf: geoJSONURL),
                case .some = try? Features.fromGeoJSON(data) else {
                    XCTFail("Can't extract geometry from GeoJSON data from: \(geoJSONURL.lastPathComponent)")
                    continue
            }
        }
    }

    func testGeoJSONFromString() {
        for geoJSONURL in geoJsonUrls {
            guard let string = try? String(contentsOf: geoJSONURL),
                case .some = try? Features.fromGeoJSON(string) else {
                    XCTFail("Can't extract geometry from GeoJSON string from: \(geoJSONURL.lastPathComponent)")
                    continue
            }
        }
    }
}
