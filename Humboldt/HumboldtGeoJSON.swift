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

private func GEOJSONGeometryFromDictionaryRepresentation(dictionary: Dictionary<String,AnyObject>) -> Geometry? {

    if let geometryDict = dictionary["geometry"] as? Dictionary<String,AnyObject>,
        let geometryType = geometryDict["type"] as? String,
        let coordinatesNSArray = geometryDict["coordinates"] as? NSArray {
            
            switch geometryType {
            case "Point":
                if let coordinates = coordinatesNSArray as? [[Double]],
                    let sequence = GEOJSONSequenceFromArrayRepresentation(coordinates) {
                        let GEOSGeom = GEOSGeom_createPoint_r(GEOS_HANDLE, sequence)
                        return Waypoint(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
                }
                
            case "MultiPoint":
                var pointArray = Array<COpaquePointer>()
                if let coordinatesNSArray = coordinatesNSArray as? [[Double]] {
                    for singlePointCoordinates in coordinatesNSArray {
                        if let sequence = GEOJSONSequenceFromArrayRepresentation([singlePointCoordinates]) {
                                let GEOSGeom = GEOSGeom_createPoint_r(GEOS_HANDLE, sequence)
                                pointArray.append(GEOSGeom)
                        } else {
                            return nil
                        }
                    }
                }
                let GEOSGeom = GEOSGeom_createCollection_r(GEOS_HANDLE, Int32(4), &pointArray, UInt32(pointArray.count))
                return MultiPoint(GEOSGeom: GEOSGeom, destroyOnDeinit: true)

            case "LineString":
                if let coordinates = coordinatesNSArray as? [[Double]],
                    let sequence = GEOJSONSequenceFromArrayRepresentation(coordinates) {
                        let GEOSGeom = GEOSGeom_createLineString_r(GEOS_HANDLE, sequence)
                        return LineString(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
                }
            
            case "MultiLineString":
                return MultiLineString(GEOSGeom: nil, destroyOnDeinit: true)
            
            case "Polygon":
                if var coordinates = coordinatesNSArray as? [[[Double]]] {
                    return GEOJSONCreatePolygonFromRepresentation(coordinates)
                }
            
            case "MultiPolygon":
                var polygons = Array<Polygon>()
                for representation in coordinatesNSArray {
                    if let representation = representation as? [[[Double]]],
                    let geom = GEOJSONCreatePolygonFromRepresentation(representation) {
                        polygons.append(geom)
                    } else {
                        return nil
                    }
                }
                return MultiPolygon(polygons: polygons)
            
            case "GeometryCollection":
                return GeometryCollection(GEOSGeom: nil, destroyOnDeinit: true)
                
            default:
                return nil
            }
            return nil
            //                let coordinates = geometryDict["coordinates"] as? Array {
            //                    println("\(coordinates)")
    } else {
        return nil
    }
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

private func GEOJSONCreatePolygonFromRepresentation(representation: [[[Double]]]) -> Polygon? {
    if representation.count > 0,
        let sequence = GEOJSONSequenceFromArrayRepresentation(representation[0]) {
            let linearring = GEOSGeom_createLinearRing_r(GEOS_HANDLE, sequence)
            let GEOSGeom = GEOSGeom_createPolygon_r(GEOS_HANDLE, linearring, nil, 0)
            return Polygon(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
    }
    return nil
}
