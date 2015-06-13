import UIKit
import GEOSwift
import MapKit
//: # GEOSwift
//: _Topography made simple, in Swift._
//:
//: Easily handle all kind of geographical objects (points, linestrings, polygons etc.) and all related topographic operations (intersections, overlapping etc.).
//: GEOSwift is basically a MIT-licensed Swift interface to the OSGeo's GEOS library routines*, plus some convenience features for iOS developers as:
//: * MapKit integration
//: * Quicklook integration
//: * GEOJSON parsing
//:
//: ### Handle a geographical data model
//:
//:     Point, LineString, Polygon, MultiPoint, MultiLineString, MultiPolygon, GeometryCollection
//:

// Create a POINT from its WKT representation.
let point = Waypoint(WKT: "POINT(10 45)")

// A geometry can be created even using the constructor `Geometry.create(WKT)` and casting the returned value to the desired subclass.
let geometry1 = Geometry.create("POLYGON((35 10, 45 45.5, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))")

// The same geometry can be represented in binary form as a Well Known Binary.
let WKB: NSData = geometryWKB()
let geometry2 = Geometry.create(WKB.bytes, size: WKB.length)

if geometry1 == geometry2 && geometry1 != point {
    println("The two geometries are equal!\nAh, and geometry objects conform to the Equatable protocol.")
}

// Examples of valid WKT geometries representations are:
// POINT(6 10)
// LINESTRING(35 10, 45 45, 15 40, 10 20, 35 10)
// LINESTRING(3 4,10 50,20 25)
// POLYGON((1 1,5 1,5 5,1 5,1 1),(2 2, 3 2, 3 3, 2 3,2 2))
// MULTIPOINT(3.5 5.6,4.8 10.5)
// MULTILINESTRING((3 4,10 50,20 25),(-5 -8,-10 -8,-15 -4))
// MULTIPOLYGON(((1 1,5 1,5 5,1 5,1 1),(2 2, 3 2, 3 3, 2 3,2 2)),((3 3,6 2,6 4,3 3)))
// GEOMETRYCOLLECTION(POINT(4 6),LINESTRING(4 6,7 10))

//: ### Mapkit integration
//:
//: Convert the geometries to a MKShape subclass, ready to be added as annotations to a MKMapView
//:
let shape1 = point!.mapShape()
let shape2 = geometry1!.mapShape()
let annotations = [shape1, shape2]

//: ### Quicklook integration
//:
//: Humboldt geometries are integrated with Quicklook!
//: This means that while debugging you can inspect complex geometries and see what they represent: just stop on the variable with the mouse cursor or select the Geometry instance and press backspace in the Debug Area to see a preview.
//: In Playgrounds you can display them just as any other object, like this:
geometry2
//: ### GEOJSON parsing
//:
//: Your geometries can be loaded from a GEOJSON file.
//:
if let geoJSONURL = NSBundle.mainBundle().URLForResource("multipolygon", withExtension: "geojson"),
    let geometries = Geometry.fromGeoJSON(geoJSONURL),
    let italy = geometries[0] as? MultiPolygon
{
    italy
    
//: ### Topological operations:
//:
    italy.buffer(width: 1)
    italy.boundary()
    italy.centroid()
    italy.convexHull()
    italy.envelope()
    italy.pointOnSurface()
    italy.intersection(geometry2!)
    italy.difference(geometry2!)
    italy.union(geometry2!)
    
//: ### Predicates:
//:
    italy.isDisjoint(geometry2!)
    italy.touches(geometry2!)
    italy.intersects(geometry2!)
    italy.crosses(geometry2!)
    italy.isWithin(geometry2!)
    italy.contains(geometry2!)
    italy.overlaps(geometry2!)
    italy.equal(geometry2!)
    italy.isRelated(geometry2!, pattern: "TF0")
    
}
//: [GEOS](http://trac.osgeo.org/geos/) stands for Geometry Engine - Open Source, and is a C++ library, ported from the [Java Topology Suite](http://sourceforge.net/projects/jts-topo-suite/). GEOS implements the OpenGIS [Simple Features for SQL](http://www.opengeospatial.org/standards/sfs) spatial predicate functions and spatial operators. GEOS, now an OSGeo project, was initially developed and maintained by [Refractions Research](http://www.refractions.net/) of Victoria, Canada.
//:
//: GEOSwift was released by Andrea Cremaschi ([@andreacremaschi](https://twitter.com/andreacremaschi)) under a MIT license. See LICENSE for more information.
