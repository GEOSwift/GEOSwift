//
//  SnapshotImage.swift
//  GEOSwiftTests
//
//  Created by Andrew Hershberger on 7/23/18.
//  Copyright © 2018 andreacremaschi. All rights reserved.
//

import Foundation

enum SnapshotImage: String {
    case waypoint
    case linearRing = "linearring"
    case polygon
    case geometryCollection = "geometrycollection"

    var name: String {
        return rawValue + ".png"
    }

    var data: Data? {
        guard let url = Bundle(for: BundleLocator.self).url(forResource: rawValue, withExtension: "png") else {
            return nil
        }
        return try? Data(contentsOf: url)
    }
}

private class BundleLocator {}
