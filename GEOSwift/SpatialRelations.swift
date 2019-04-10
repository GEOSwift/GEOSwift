//
//  Predicates.swift
//
//  Created by Andrea Cremaschi on 10/06/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

import Foundation

/** 
Spatial predicates methods

All of the following spatial predicate methods take another Geometry instance (other) as a parameter and return a bool.
*/
public extension Geometry {

    /// - returns: TRUE if the geometry is spatially equal to `geometry`
    @objc func equals(_ geometry: Geometry) -> Bool {
        return GEOSEquals_r(GEOS_HANDLE, storage.GEOSGeom, geometry.storage.GEOSGeom) > 0
    }

    /// - returns: TRUE if the geometry is spatially disjoint to `geometry`
    @objc func disjoint(_ geometry: Geometry) -> Bool {
        return GEOSDisjoint_r(GEOS_HANDLE, storage.GEOSGeom, geometry.storage.GEOSGeom) > 0
    }

    /// - returns: TRUE if the geometry spatially touches `geometry`
    @objc func touches(_ geometry: Geometry) -> Bool {
        return GEOSTouches_r(GEOS_HANDLE, storage.GEOSGeom, geometry.storage.GEOSGeom) > 0
    }

    /// - returns: TRUE if the geometry spatially intersects `geometry`
    @objc func intersects(_ geometry: Geometry) -> Bool {
        return GEOSIntersects_r(GEOS_HANDLE, storage.GEOSGeom, geometry.storage.GEOSGeom) > 0
    }

    /// - returns: TRUE if the geometry spatially crosses `geometry`
    @objc func crosses(_ geometry: Geometry) -> Bool {
        return GEOSCrosses_r(GEOS_HANDLE, storage.GEOSGeom, geometry.storage.GEOSGeom) > 0
    }

    /// - returns: TRUE if the geometry is spatially within `geometry`
    @objc func within(_ geometry: Geometry) -> Bool {
        return GEOSWithin_r(GEOS_HANDLE, storage.GEOSGeom, geometry.storage.GEOSGeom) > 0
    }

    /// - returns: TRUE if the geometry spatially contains `geometry`
    @objc func contains(_ geometry: Geometry) -> Bool {
        return GEOSContains_r(GEOS_HANDLE, storage.GEOSGeom, geometry.storage.GEOSGeom) > 0
    }

    /// - returns: TRUE if the geometry spatially overlaps `geometry`
    @objc func overlaps(_ geometry: Geometry) -> Bool {
        return GEOSOverlaps_r(GEOS_HANDLE, storage.GEOSGeom, geometry.storage.GEOSGeom) > 0
    }

    /// - returns: TRUE if the geometry spatially covers `geometry`
    @objc func covers(_ geometry: Geometry) -> Bool {
        return GEOSCovers_r(GEOS_HANDLE, storage.GEOSGeom, geometry.storage.GEOSGeom) > 0
    }

    /**
    - parameter pattern: A String following the Dimensionally Extended Nine-Intersection Model (DE-9IM).
    
    - returns: TRUE if the geometry spatially relates `geometry`, by testing for intersections between the
               Interior, Boundary and Exterior of the two geometries as specified by the values in the pattern.
    */
    @objc func relate(_ geometry: Geometry, pattern: String) -> Bool {
        return GEOSRelatePattern_r(GEOS_HANDLE,
                                   storage.GEOSGeom,
                                   geometry.storage.GEOSGeom,
                                   (pattern as NSString).utf8String) > 0
    }
}
