import Foundation
import GEOSwift

class GeometryModel: ObservableObject {
    @Published var geometries = [SelectableIdentifiableGeometry]()
    var selectedGeometries: [SelectableIdentifiableGeometry] {
        geometries.filter({ $0.selected })
    }
    @Published var hasError = false
    @Published var errorMessage = ""

    func buffer(_ input: some GeometryConvertible<XY>, bufferSize: Double = 3) -> Void {
        do {
            if let resultGeometry = try input.geometry.buffer(by: bufferSize) {
                geometries.append(SelectableIdentifiableGeometry(resultGeometry))
            }
        } catch {
            handleError(error)
        }
    }
    
    func convexHull(_ input: some GeometryConvertible<XY>) -> Void {
        do {
            let resultGeometry = try input.geometry.convexHull()
            geometries.append(SelectableIdentifiableGeometry(resultGeometry))
        } catch {
            handleError(error)
        }
    }
    
    func intersection(firstGeometry: some GeometryConvertible<XY>, secondGeometry: some GeometryConvertible<XY>) -> Void {
        do {
            if let resultGeometry = try firstGeometry.intersection(with: secondGeometry) {
                geometries.append(SelectableIdentifiableGeometry(resultGeometry))
            }
        } catch {
            handleError(error)
        }
    }

    func envelope(_ input: some GeometryConvertible<XY>) -> Void {
        do {
            let resultGeometry = try input.envelope().geometry
            geometries.append(SelectableIdentifiableGeometry(resultGeometry))
        } catch {
            handleError(error)
        }
    }
    
    func difference(firstGeometry: some GeometryConvertible<XY>, secondGeometry: some GeometryConvertible<XY>) -> Void {
        do {
            if let resultGeometry = try firstGeometry.difference(with: secondGeometry) {
                geometries.append(SelectableIdentifiableGeometry(resultGeometry))
            }
        } catch {
            handleError(error)
        }
    }
    
    func union(firstGeometry: some GeometryConvertible<XY>, secondGeometry: some GeometryConvertible<XY>) -> Void {
        do {
            if let resultGeometry = try firstGeometry.union(with: secondGeometry) {
                geometries.append(SelectableIdentifiableGeometry(resultGeometry))
            }
        } catch {
            handleError(error)
        }
    }
    
    func pointOnSurface(_ input: some GeometryConvertible<XY>) -> Void {
        do {
            let resultGeometry = try Geometry<XY>.point(input.pointOnSurface())
            geometries.append(SelectableIdentifiableGeometry(resultGeometry))
        } catch {
            handleError(error)
        }
    }
    
    func centroid(_ input: some GeometryConvertible<XY>) -> Void {
        do {
            let resultGeometry = try Geometry<XY>.point(input.centroid())
            geometries.append(SelectableIdentifiableGeometry(resultGeometry))
        } catch {
            handleError(error)
        }
    }
    
    func boundary(_ input: some GeometryConvertible<XY>) -> Void {
        var resultGeometry: Geometry<XY>
        do {
            switch input.geometry {
            case let .multiPoint(input):
                resultGeometry = try input.boundary()
                geometries.append(SelectableIdentifiableGeometry(resultGeometry))
            case let .polygon(input):
                resultGeometry = try input.boundary()
                geometries.append(SelectableIdentifiableGeometry(resultGeometry))
            case let .multiPolygon(input):
                resultGeometry = try input.boundary()
                geometries.append(SelectableIdentifiableGeometry(resultGeometry))
            case let .lineString(input):
                resultGeometry = try input.boundary()
                geometries.append(SelectableIdentifiableGeometry(resultGeometry))
            case let .multiLineString(input):
                resultGeometry = try input.boundary()
                geometries.append(SelectableIdentifiableGeometry(resultGeometry))
            case let .point(input):
                resultGeometry = try input.boundary()
                geometries.append(SelectableIdentifiableGeometry(resultGeometry))
            case .geometryCollection:
                handleError(GEOSError.libraryError(errorMessages: ["GeometryCollection is not Boundable"]))
            }
        } catch {
            handleError(error)
        }
    }
    
    func minimumBoundingCircle(_ input: some GeometryConvertible<XY>) -> Void {
        do {
            let viewCircle = try input.minimumBoundingCircle()
            if let resultGeometry = try viewCircle.center.buffer(by: viewCircle.radius) {
                geometries.append(SelectableIdentifiableGeometry(resultGeometry))
            }
        } catch {
            handleError(error)
        }
    }
    
    func simplify(_ input: some GeometryConvertible<XY>) -> Void {
        do {
            let resultGeometry = try input.simplify(withTolerance: 3)
            geometries.append(SelectableIdentifiableGeometry(resultGeometry))
        } catch {
            handleError(error)
        }
    }
    
    func minimumRotatedRectangle(_ input: some GeometryConvertible<XY>) -> Void {
        do {
            let resultGeometry = try input.minimumRotatedRectangle()
            geometries.append(SelectableIdentifiableGeometry(resultGeometry))
        } catch {
            handleError(error)
        }
    }
    
    func minimumWidth(_ input: some GeometryConvertible<XY>) -> Void {
        do {
            let resultGeometry = try Geometry<XY>.lineString(input.minimumWidth())
            geometries.append(SelectableIdentifiableGeometry(resultGeometry))
        } catch {
            handleError(error)
        }
    }
    
    func clear() {
        geometries = geometries.filter { !$0.selected }
    }
    
    func importGeometry(_ result: Result<URL, Error>) {
        do {
            let selectedFile: URL = try result.get()
            _ = selectedFile.startAccessingSecurityScopedResource()
            let decoder = JSONDecoder()
            if let data = try? Data(contentsOf: selectedFile),
               let geoJSON = try? decoder.decode(GeoJSON<XY>.self, from: data),
               case let .featureCollection(featureCollection) = geoJSON {
                let geometriesArray: [SelectableIdentifiableGeometry] = featureCollection.features.compactMap { feature in
                    guard let geometry = feature.geometry else {
                        handleError(GEOSwiftError.invalidJSON)
                        return nil
                    }
                    return SelectableIdentifiableGeometry(geometry)
                }
                geometries.append(contentsOf: geometriesArray)
            }
            selectedFile.stopAccessingSecurityScopedResource()
        } catch {
            handleError(error)
        }
    }
    
    func handleError(_ error: Error) {
        switch error {
        case let GEOSError.libraryError(errorMessages: errorArray):
            errorMessage = errorArray.first ?? "A library error occured"
        case GEOSError.noMinimumBoundingCircle:
            errorMessage = "No minimum bounding circle"
        case let GEOSError.typeMismatch(actual: actual, expected: expected):
            errorMessage = "Expected \(String(describing: expected)), but retured \(String(describing: actual))"
        case GEOSError.unableToCreateContext:
            errorMessage = "Unable to create context"
        case GEOSError.wkbDataWasEmpty:
            errorMessage = "WKB data was empty"
        case GEOSwiftError.invalidCoordinates:
            errorMessage = "Invalid coordinates"
        case GEOSwiftError.invalidFeatureId:
            errorMessage = "Invalid feature ID"
        case GEOSwiftError.invalidGeoJSONType:
            errorMessage = "Invalid GEOJSON type"
        case GEOSwiftError.invalidJSON:
            errorMessage = "Invalid JSON"
        case GEOSwiftError.mismatchedGeoJSONType:
            errorMessage = "Mismatched GEOJSON type"
        case GEOSwiftError.ringNotClosed:
            errorMessage = "Ring not closed"
        case GEOSwiftError.tooFewCoordinates:
            errorMessage = "Too few coordinates"
        case GEOSwiftError.tooFewRings:
            errorMessage = "Too few rings"
        case let GEOSwiftError.unexpectedEnvelopeResult(geometry):
            errorMessage = "Unexpected envelope result with geometry: \(geometry)"
        default:
            errorMessage = error.localizedDescription
        }
        
        // Allow time for the previous view to be dismissed 
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.hasError = true
        }
    }
}
