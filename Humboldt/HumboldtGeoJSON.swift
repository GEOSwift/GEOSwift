//
//  HumboldtGeoJSON.swift
//  HumboldtDemo
//
//  Created by Andrea Cremaschi on 27/05/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

import Foundation
import geos

public extension Geometry {
    public class func fromGeoJSON(URL: NSURL) -> Array<Geometry>? {
        var parseError: NSError?
        
        if let JSONData = NSData(contentsOfURL: URL),

            // read JSON file
            let parsedObject = NSJSONSerialization.JSONObjectWithData(JSONData,
                options: NSJSONReadingOptions.AllowFragments,
                error:&parseError) as? NSDictionary,

            // is the root a Dictionary with a "type" key of value "FeatureCollection"?
            let rootFeature = parsedObject as? Dictionary<String, AnyObject>,
            let type = rootFeature["type"] as? String {
                if type == "FeatureCollection",
                    
                    // is there a "features" key of type NSArray?
                    let featureCollection = rootFeature["features"] as? NSArray {

                        // map every geometry representation to a GEOS geometry
                        let features = featureCollection as Array
                        var geometries = Array<Geometry>()
                        for feature in features {
                            if let feat1 = feature as? NSDictionary,
                                let feat2 = feat1 as? Dictionary<String,AnyObject>,
                                let geom = GEOJSONGeometryFromDictionaryRepresentation(feat2) {
                                    geometries.append(geom)
                            } else {
                                return nil
                            }
                        }
                        return geometries
                }
        }
        return nil
    }
}


private func GEOJSONGeometry(type: String, coordinatesNSArray: NSArray) -> Geometry? {
    switch type {
    case "Point":
        // For type "Point", the "coordinates" member must be a single position.
        if let coordinates = coordinatesNSArray as? [Double],
            let sequence = GEOJSONSequenceFromArrayRepresentation([coordinates]) {
                let GEOSGeom = GEOSGeom_createPoint_r(GEOS_HANDLE, sequence)
                return Waypoint(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
        }
        
    case "MultiPoint":
        // For type "MultiPoint", the "coordinates" member must be an array of positions.
        var pointArray = Array<Waypoint>()
        if let coordinatesNSArray = coordinatesNSArray as? [[Double]] {
            for singlePointCoordinates in coordinatesNSArray {
                if let sequence = GEOJSONSequenceFromArrayRepresentation([singlePointCoordinates]) {
                    let GEOSGeom = GEOSGeom_createPoint_r(GEOS_HANDLE, sequence)
                    let point = Waypoint(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
                    pointArray.append(point)
                } else {
                    return nil
                }
            }
        }
        return MultiPoint(points: pointArray)
        
    case "LineString":
        // For type "LineString", the "coordinates" member must be an array of two or more positions.
        if let coordinates = coordinatesNSArray as? [[Double]],
            let sequence = GEOJSONSequenceFromArrayRepresentation(coordinates) {
                let GEOSGeom = GEOSGeom_createLineString_r(GEOS_HANDLE, sequence)
                return LineString(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
        }
        
    case "MultiLineString":
        // For type "MultiLineString", the "coordinates" member must be an array of LineString coordinate arrays.
        if let linestringsRepresentation = coordinatesNSArray as? [[[Double]]] {
            var linestrings: Array<LineString> = []
            for coordinates in linestringsRepresentation {
                if let sequence = GEOJSONSequenceFromArrayRepresentation(coordinates) {
                    let GEOSGeom = GEOSGeom_createLineString_r(GEOS_HANDLE, sequence)
                    let linestring = LineString(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
                    linestrings.append(linestring)
                } else {
                    return nil
                }
            }
            return MultiLineString(linestrings: linestrings)
        }
        return nil
        
    case "Polygon":
        return GEOJSONCreatePolygonFromRepresentation(coordinatesNSArray)
        
    case "MultiPolygon":
        // For type "MultiPolygon", the "coordinates" member must be an array of Polygon coordinate arrays.
        var polygons = Array<Polygon>()
        for representation in coordinatesNSArray {
            if let multiPolyRepresentation = representation as? [NSArray] {
                for polyRepresentation in multiPolyRepresentation {
                    if let geom = GEOJSONCreatePolygonFromRepresentation(polyRepresentation) {
                        polygons.append(geom)
                    } else {
                        return nil
                    }
                }
            } else {
                return nil
            }
        }
        return MultiPolygon(polygons: polygons)
    
    default:
        return nil
    }
    
    return nil
}

private func GEOJSONGeometryFromDictionaryRepresentation(dictionary: Dictionary<String,AnyObject>) -> Geometry? {

    if  let geometryDict = dictionary["geometry"] as? Dictionary<String,AnyObject>,
        let geometryType = geometryDict["type"] as? String {
            
            switch geometryType {
                
                case "GeometryCollection":
                    // A GeoJSON object with type "GeometryCollection" is a geometry object which represents a collection of geometry objects.
                    // A geometry collection must have a member with the name "geometries". The value corresponding to "geometries" is an array. Each element in this array is a GeoJSON geometry object.
                    
                    if let geometriesNSArray = geometryDict["geometries"] as? NSArray,
                        let geometriesArray = geometriesNSArray as? Array<NSDictionary> {
                            
                        var geometries = Array<Geometry>()
                        for geometryNSDictionary in geometriesArray {
                            if let geometryType = geometryNSDictionary["type"] as? String,
                                let coordinatesNSArray = geometryNSDictionary["coordinates"] as? NSArray,
                                let geometry = GEOJSONGeometry(geometryType, coordinatesNSArray) {
                                    geometries.append(geometry)
                            } else {
                                return nil
                            }
                        }
                        return GeometryCollection(geometries: geometries)
                }
                
                default:
                    if let coordinatesNSArray = geometryDict["coordinates"] as? NSArray {
                        return GEOJSONGeometry(geometryType, coordinatesNSArray)
                }
            }
            
    }
    return nil
}

private func GEOJSONCoordinatesFromArrayRepresentation(array: [[Double]]) -> [Coordinate]? {
    return array.map {
        (var coordinatePair) -> Coordinate in
        return Coordinate(x: coordinatePair[0], y: coordinatePair[1])
    }
}

private func GEOJSONSequenceFromArrayRepresentation(representation: [[Double]]) -> COpaquePointer? {
    if let coordinates = GEOJSONCoordinatesFromArrayRepresentation(representation) {
        var sequence = GEOSCoordSeq_create_r(GEOS_HANDLE, UInt32(coordinates.count), 2)
        for (index, coord) in enumerate(coordinates) {
            if (GEOSCoordSeq_setX_r(GEOS_HANDLE, sequence, UInt32(index), coord.x) == 0) ||
                (GEOSCoordSeq_setY_r(GEOS_HANDLE, sequence, UInt32(index), coord.y) == 0) {
                    return nil
            }
        }
        return sequence
    }
    return nil
}

private func GEOJSONCreateLinearRingFromRepresentation(representation: [[Double]]) -> LinearRing? {
    if let sequence = GEOJSONSequenceFromArrayRepresentation(representation) {
        let GEOSGeom = GEOSGeom_createLinearRing_r(GEOS_HANDLE, sequence)
        return LinearRing(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
    }
    return nil
}

private func GEOJSONCreatePolygonFromRepresentation(representation: NSArray) -> Polygon? {
    
    // For type "Polygon", the "coordinates" member must be an array of LinearRing coordinate arrays. For Polygons with multiple rings, the first must be the exterior ring and any others must be interior rings or holes.
    
    if var coordinates = representation as? [[Double]] {
        // array of LinearRing coordinate arrays
        if let shell = GEOJSONCreateLinearRingFromRepresentation(coordinates) {
            let polygon = Polygon(shell: shell, holes: nil)
            return polygon
        }
    } else {
        if var ringsCoords = representation as? [[[Double]]] {
            if ringsCoords.count == 0 { return nil }
            // Polygons with multiple rings
            var rings: Array<LinearRing> = ringsCoords.map({
                (ringCoords: [[Double]]) -> LinearRing in
                let linearRing: LinearRing
                if let sequence = GEOJSONSequenceFromArrayRepresentation(ringCoords) {
                    let GEOSGeom = GEOSGeom_createLinearRing_r(GEOS_HANDLE, sequence)
                    linearRing = LinearRing(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
                } else {
                    let GEOSGeom = GEOSGeom_createEmptyLineString_r(GEOS_HANDLE)
                    linearRing = LinearRing(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
                }
                return linearRing
            })
            let shell = rings[0]
            rings.removeAtIndex(0)
            let polygon = Polygon(shell: shell, holes: rings)
            return polygon
        }
    }
    return nil
}
