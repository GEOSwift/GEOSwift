//
//  HumboldtQuickLook.swift
//  HumboldtDemo
//
//  Created by Andrea Cremaschi on 21/05/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

import Foundation
import UIKit
import MapKit

protocol HumboldtQuickLook {
    func drawInSnapshot(snapshot: MKMapSnapshot, mapRect: MKMapRect)
}

public extension Geometry {
    public func debugQuickLookObject() -> AnyObject? {
        return self.WKT
    }
}