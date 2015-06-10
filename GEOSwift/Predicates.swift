//
//  Predicates.swift
//
//  Created by Andrea Cremaschi on 10/06/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

import Foundation
import geos

/** @name Spatial predicates methods
* All of the following spatial predicate methods take another Geometry instance (other) as a parameter, and return a boolean.
*/
public extension Geometry {
 
    /** Returns TRUE if the DE-9IM intersection matrix for the two geometries is "FF*FF****".
    */
    public func isDisjoint(geometry: Geometry) -> Bool {
        return GEOSDisjoint_r(GEOS_HANDLE, self.geometry, geometry.geometry) > 0;
    }
    
    /** Returns TRUE if the DE-9IM intersection matrix for the two geometries is "FT*******", "F**T*****" or "F***T****".
    */
    public func touches(geometry: Geometry) -> Bool {
        return GEOSTouches_r(GEOS_HANDLE, self.geometry, geometry.geometry) > 0;
    }
    
    /** Returns TRUE if isDisjointFromGeometry is FALSE.
    */
    public func intersects(geometry: Geometry) -> Bool {
        return GEOSIntersects_r(GEOS_HANDLE, self.geometry, geometry.geometry) > 0;
    }
    
    /** Returns TRUE if the DE-9IM intersection matrix for the two Geometries is "T*T******" (for a point and a curve,a point and an area or a line and an area) 0******** (for two curves).
    */
    public func crosses(geometry: Geometry) -> Bool {
        return GEOSCrosses_r(GEOS_HANDLE, self.geometry, geometry.geometry) > 0;
    }
    
    /** Returns TRUE if the DE-9IM intersection matrix for the two geometries is "T*F**F***".
    */
    public func isWithin(geometry: Geometry) -> Bool {
        return GEOSWithin_r(GEOS_HANDLE, self.geometry, geometry.geometry) > 0;
    }
    
    /** Returns TRUE if isWithinGeometry is FALSE.
    */
    public func contains(geometry: Geometry) -> Bool {
        return GEOSContains_r(GEOS_HANDLE, self.geometry, geometry.geometry) > 0;
    }
    
    /** Returns TRUE if the DE-9IM intersection matrix for the two geometries is "T*T***T**" (for two points or two surfaces) "1*T***T**" (for two curves).
    */
    public func overlaps(geometry: Geometry) -> Bool {
        return GEOSOverlaps_r(GEOS_HANDLE, self.geometry, geometry.geometry) > 0;
    }
    
    /** Returns TRUE if the DE-9IM intersection matrix for the two geometries is "T*F**FFF*".
    */
    public func equal(geometry: Geometry) -> Bool {
        return GEOSEquals_r(GEOS_HANDLE, self.geometry, geometry.geometry) > 0;
    }
    
    /** Returns TRUE if the elements in the DE-9IM intersection matrix for this geometry and the other matches the given pattern – a string of nine characters from the alphabet: {T, F, *, 0}.
    */
    public func isRelated(geometry: Geometry, pattern: String) -> Bool {
        return GEOSRelatePattern_r(GEOS_HANDLE, self.geometry, geometry.geometry, (pattern as NSString).UTF8String) > 0;
    }

}
