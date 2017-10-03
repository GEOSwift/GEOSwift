//
//  Feature.swift
//  GEOSwift
//
//  Created by Paul Aigueperse on 17-10-02.
//  Copyright © 2017 andreacremaschi. All rights reserved.
//

import Foundation

public class Feature {
    
    public var geometries: Array<Geometry>?
    public var properties: NSDictionary?
    
    init() {
        geometries = Array<Geometry>()
    }
}
