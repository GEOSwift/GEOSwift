//
//  GeoJSON.swift
//
//  Created by Andrea Cremaschi on 27/05/15.
//  Copyright (c) 2015 andreacremaschi. All rights reserved.
//

import Foundation

public enum GEOJSONParseError: Error {
    case invalidJSON
    case invalidGEOJSON
}

public class Feature{
    public var geometries: Array<Geometry>?
    public var properties: NSDictionary?

    init() {
        geometries = Array<Geometry>()
    }
}

public extension Geometry {
    /**
     Creates an `Feature' array instance from a GeoJSON file.

     - parameter URL: the URL pointing to the GeoJSON file.

     :returns: An optional `Array` of `Feature` instances.
     */
    public class func fromGeoJSON(_ URL: Foundation.URL) throws -> [Feature]?{

        var features: [Feature]?

        if let JSONData = try? Data(contentsOf: URL) {

            do {
                // read JSON file
                let parsedObject = try JSONSerialization.jsonObject(with: JSONData,
                                                                    options: JSONSerialization.ReadingOptions.allowFragments) as? NSDictionary

                // is the root a Dictionary with a "type" key of value "FeatureCollection"?
                if let rootObject = parsedObject as? Dictionary<String, AnyObject> {
                    features = Geometry.fromGeoJSONDictionary(rootObject)
                    return features
                } else {
                    throw GEOJSONParseError.invalidGEOJSON
                }
            } catch _ {
                throw GEOJSONParseError.invalidJSON
            }
        }

        return nil
    }

    /**
     Creates an `Array` of `Feature` instances from a GeoJSON dictionary.

     :param: dictionary a dictionary following GeoJSON format specification.

     :returns: An optional `Array` of `Feature` instances.
     */
    public class func fromGeoJSONDictionary(_ dictionary: Dictionary<String, AnyObject>) -> [Feature]? {
        return ParseGEOJSONObject(dictionary)
    }
}

// MARK: - Private parsing functions

private func ParseGEOJSONObject(_ GEOJSONObject: Dictionary<String, AnyObject>) -> [Feature]? {

    if let type = GEOJSONObject["type"] as? String {

        // is there a "features" key of type NSArray?
        switch (type) {
        case "Feature":
            if let feat = ParseGEOJSONFeature(GEOJSONObject) {
                let f = Feature()
                f.geometries = [feat.0]
                f.properties = feat.1

                return [f]
            }

        case "FeatureCollection":
            if let featureCollection = GEOJSONObject["features"] as? NSArray {
                return ParseGEOJSONFeatureCollection(featureCollection)
            }

        case "GeometryCollection":
            if let geometryCollection = GEOJSONObject["geometries"] as? NSArray {
                let f = Feature()
                f.geometries = ParseGEOJSONGeometryCollection(geometryCollection)

                return [f]
            }

        default:
            if let coordinates = GEOJSONObject["coordinates"] as? NSArray,
                let geometry = ParseGEOJSONGeometry(type, coordinatesNSArray: coordinates)

            {
                let f = Feature()
                f.geometries = [geometry]
                return [f]
            }
        }
    }
    return nil
}

private func ParseGEOJSONFeatureCollection(_ features: NSArray) -> [Feature]? {
    // map every feature representation to a GEOS geometry

    var featuresArray = [Feature]()

    for feature in features {
        if let feat1 = feature as? NSDictionary,
            let feat2 = feat1 as? Dictionary<String,AnyObject>,
            let feat = ParseGEOJSONFeature(feat2) {
            let f = Feature()
            f.geometries = [feat.0]
            f.properties = feat.1
            featuresArray.append(f)

        } else {
            return nil
        }
    }
    return featuresArray
}

private func ParseGEOJSONFeature(_ GEOJSONFeature: Dictionary<String, AnyObject>) -> (Geometry, NSDictionary)? {
    if let geometry = GEOJSONFeature["geometry"] as? Dictionary<String,AnyObject>,
        let properties = GEOJSONFeature["properties"] as? NSDictionary,

        let geometryType = geometry["type"] as? String,
        let geometryCoordinates = geometry["coordinates"] as? NSArray {
        return (ParseGEOJSONGeometry(geometryType, coordinatesNSArray: geometryCoordinates)!, properties)
    }
    return nil
}

private func ParseGEOJSONGeometryCollection(_ geometries: NSArray) -> [Geometry]? {
    // map every geometry representation to a GEOS geometry
    var GEOSGeometries = Array<Geometry>()
    for geometry in geometries {
        if let geom1 = geometry as? NSDictionary,
            let geom2 = geom1 as? Dictionary<String,AnyObject>,
            let geomType = geom2["type"] as? String,
            let geomCoordinates = geom2["coordinates"] as? NSArray,
            let geom = ParseGEOJSONGeometry(geomType, coordinatesNSArray: geomCoordinates) {
            GEOSGeometries.append(geom)
        } else {
            return nil
        }
    }
    return GEOSGeometries
}

private func ParseGEOJSONGeometry(_ type: String, coordinatesNSArray: NSArray) -> Geometry? {
    switch type {
    case "Point":
        // For type "Point", the "coordinates" member must be a single position.
        guard let coordinates = coordinatesNSArray as? [Double],
            let sequence = GEOJSONSequenceFromArrayRepresentation([coordinates]),
            let GEOSGeom = GEOSGeom_createPoint_r(GEOS_HANDLE, sequence) else {
                return nil
        }
        return Waypoint(GEOSGeom: GEOSGeom, destroyOnDeinit: true)

    case "MultiPoint":
        // For type "MultiPoint", the "coordinates" member must be an array of positions.
        guard let coordinatesNSArray = coordinatesNSArray as? [[Double]] else {
            return nil
        }
        var pointArray = Array<Waypoint>()
        for singlePointCoordinates in coordinatesNSArray {
            guard let sequence = GEOJSONSequenceFromArrayRepresentation([singlePointCoordinates]),
                let GEOSGeom = GEOSGeom_createPoint_r(GEOS_HANDLE, sequence) else {
                    return nil
            }
            let point = Waypoint(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
            pointArray.append(point)
        }
        return MultiPoint(points: pointArray)

    case "LineString":
        // For type "LineString", the "coordinates" member must be an array of two or more positions.
        guard let coordinates = coordinatesNSArray as? [[Double]],
            let sequence = GEOJSONSequenceFromArrayRepresentation(coordinates),
            let GEOSGeom = GEOSGeom_createLineString_r(GEOS_HANDLE, sequence) else {
                return nil
        }
        return LineString(GEOSGeom: GEOSGeom, destroyOnDeinit: true)

    case "MultiLineString":
        // For type "MultiLineString", the "coordinates" member must be an array of LineString coordinate arrays.
        guard let linestringsRepresentation = coordinatesNSArray as? [[[Double]]] else {
            return nil
        }
        var linestrings: Array<LineString> = []
        for coordinates in linestringsRepresentation {
            guard let sequence = GEOJSONSequenceFromArrayRepresentation(coordinates),
                let GEOSGeom = GEOSGeom_createLineString_r(GEOS_HANDLE, sequence) else {
                    return nil
            }
            let linestring = LineString(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
            linestrings.append(linestring)
        }
        return MultiLineString(linestrings: linestrings)

    case "Polygon":
        return GEOJSONCreatePolygonFromRepresentation(coordinatesNSArray)

    case "MultiPolygon":
        // For type "MultiPolygon", the "coordinates" member must be an array of Polygon coordinate arrays.
        var polygons = Array<Polygon>()
        for representation in coordinatesNSArray {
            guard let multiPolyRepresentation = representation as? [NSArray] else {
                return nil
            }
            for polyRepresentation in multiPolyRepresentation {
                guard let geom = GEOJSONCreatePolygonFromRepresentation(polyRepresentation) else {
                    return nil
                }
                polygons.append(geom)
            }
        }
        return MultiPolygon(polygons: polygons)

    default:
        return nil
    }
}

// MARK:

private func GEOJSONGeometryFromDictionaryRepresentation(_ dictionary: Dictionary<String,AnyObject>) -> Geometry? {

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
                        let geometry = ParseGEOJSONGeometry(geometryType, coordinatesNSArray: coordinatesNSArray) {
                        geometries.append(geometry)
                    } else {
                        return nil
                    }
                }
                return GeometryCollection(geometries: geometries)
            }

        default:
            if let coordinatesNSArray = geometryDict["coordinates"] as? NSArray {
                return ParseGEOJSONGeometry(geometryType, coordinatesNSArray: coordinatesNSArray)
            }
        }

    }
    return nil
}

private func GEOJSONCoordinatesFromArrayRepresentation(_ array: [[Double]]) -> [Coordinate]? {
    return array.map {
        coordinatePair in
        return Coordinate(x: coordinatePair[0], y: coordinatePair[1])
    }
}

private func GEOJSONSequenceFromArrayRepresentation(_ representation: [[Double]]) -> OpaquePointer? {
    if let coordinates = GEOJSONCoordinatesFromArrayRepresentation(representation) {
        let sequence = GEOSCoordSeq_create_r(GEOS_HANDLE, UInt32(coordinates.count), 2)
        for (index, coord) in coordinates.enumerated() {
            if (GEOSCoordSeq_setX_r(GEOS_HANDLE, sequence, UInt32(index), coord.x) == 0) ||
                (GEOSCoordSeq_setY_r(GEOS_HANDLE, sequence, UInt32(index), coord.y) == 0) {
                return nil
            }
        }
        return sequence
    }
    return nil
}

private func GEOJSONCreateLinearRingFromRepresentation(_ representation: [[Double]]) -> LinearRing? {
    guard let sequence = GEOJSONSequenceFromArrayRepresentation(representation),
        let GEOSGeom = GEOSGeom_createLinearRing_r(GEOS_HANDLE, sequence) else {
            return nil
    }
    return LinearRing(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
}

private func GEOJSONCreatePolygonFromRepresentation(_ representation: NSArray) -> Polygon? {

    // For type "Polygon", the "coordinates" member must be an array of LinearRing coordinate arrays. For Polygons with multiple rings, the first must be the exterior ring and any others must be interior rings or holes.

    if let coordinates = representation as? [[Double]] {
        // array of LinearRing coordinate arrays
        guard let shell = GEOJSONCreateLinearRingFromRepresentation(coordinates) else {
            return nil
        }
        let polygon = Polygon(shell: shell, holes: nil)
        return polygon
    }

    guard let ringsCoords = representation as? [[[Double]]],
        ringsCoords.count > 0 else {
            return nil
    }

    // Polygons with multiple rings
    var rings: Array<LinearRing> = ringsCoords.flatMap({
        (ringCoords: [[Double]]) -> LinearRing? in
        if let sequence = GEOJSONSequenceFromArrayRepresentation(ringCoords),
            let GEOSGeom = GEOSGeom_createLinearRing_r(GEOS_HANDLE, sequence) {
            return LinearRing(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
        } else if let GEOSGeom = GEOSGeom_createEmptyLineString_r(GEOS_HANDLE) {
            return LinearRing(GEOSGeom: GEOSGeom, destroyOnDeinit: true)
        }
        return nil
    })
    let shell = rings.remove(at: 0)
    let polygon = Polygon(shell: shell, holes: rings)
    return polygon
}
