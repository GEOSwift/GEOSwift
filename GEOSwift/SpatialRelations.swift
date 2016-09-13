//
//  Predicates.swift
//
//  Created by Andrea Cremaschi on 10/06/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

import Foundation

/** 
Spatial predicates methods

All of the following spatial predicate methods take another Geometry instance (other) as a parameter, and return a boolean.
*/
public extension Geometry {
 
    /// - returns: TRUE if the geometry is spatially equal to `geometry`
    public func equals(_ geometry: Geometry) -> Bool {
        return GEOSEquals_r(GEOS_HANDLE, self.geometry, geometry.geometry) > 0;
    }
    
    /// - returns: TRUE if the geometry is spatially disjoint to `geometry`
    public func disjoint(_ geometry: Geometry) -> Bool {
        return GEOSDisjoint_r(GEOS_HANDLE, self.geometry, geometry.geometry) > 0;
    }
    
    /// - returns: TRUE if the geometry spatially touches `geometry`
    public func touches(_ geometry: Geometry) -> Bool {
        return GEOSTouches_r(GEOS_HANDLE, self.geometry, geometry.geometry) > 0;
    }
    
    /// - returns: TRUE if the geometry spatially intersects `geometry`
    public func intersects(_ geometry: Geometry) -> Bool {
        return GEOSIntersects_r(GEOS_HANDLE, self.geometry, geometry.geometry) > 0;
    }
    
    /// - returns: TRUE if the geometry spatially crosses `geometry`
    public func crosses(_ geometry: Geometry) -> Bool {
        return GEOSCrosses_r(GEOS_HANDLE, self.geometry, geometry.geometry) > 0;
    }
    
    /// - returns: TRUE if the geometry is spatially within `geometry`
    public func within(_ geometry: Geometry) -> Bool {
        return GEOSWithin_r(GEOS_HANDLE, self.geometry, geometry.geometry) > 0;
    }
    
    /// - returns: TRUE if the geometry spatially contains `geometry`
    public func contains(_ geometry: Geometry) -> Bool {
        return GEOSContains_r(GEOS_HANDLE, self.geometry, geometry.geometry) > 0;
    }
    
    /// - returns: TRUE if the geometry spatially overlaps `geometry`
    public func overlaps(_ geometry: Geometry) -> Bool {
        return GEOSOverlaps_r(GEOS_HANDLE, self.geometry, geometry.geometry) > 0;
    }
    
    /// - returns: TRUE if the geometry spatially covers `geometry`
    public func covers(_ geometry : Geometry) -> Bool {
        return GEOSCovers_r(GEOS_HANDLE, self.geometry, geometry.geometry) > 0
    }

    /**
    - parameter pattern: A String following the Dimensionally Extended Nine-Intersection Model (DE-9IM).
    
    - returns: TRUE if the geometry spatially relates `geometry`, by testing for intersections between the Interior, Boundary and Exterior of the two geometries as specified by the values in the pattern.
    */
    public func relate(_ geometry: Geometry, pattern: String) -> Bool {
        return GEOSRelatePattern_r(GEOS_HANDLE, self.geometry, geometry.geometry, (pattern as NSString).utf8String) > 0;
    }

}
