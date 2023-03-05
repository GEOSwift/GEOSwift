import Foundation
import GEOSwift

class GeometryModel: ObservableObject {
    @Published var geometries: [IdentifiableGeometry]
    var selectedGeometries: [IdentifiableGeometry] {
        geometries.filter({ $0.selected })
    }
    @Published var hasError: Bool
    @Published var errorMessage: String
    
    init (){
        geometries = [IdentifiableGeometry]()
        hasError = false
        errorMessage = ""
    }

    func buffer(input: Geometry, bufferSize: Double = 3) -> Void {
        do {
            let resultGeometry = try input.geometry.buffer(by: bufferSize)!
            geometries.append(IdentifiableGeometry(geometry: resultGeometry))
        } catch {
            handleError(error)
        }
    }
    
    func convexHull(input: Geometry) -> Void {
        do {
            let resultGeometry = try input.geometry.convexHull()
            geometries.append(IdentifiableGeometry(geometry: resultGeometry))
        } catch {
            handleError(error)
        }
    }
    
    func intersection(input: Geometry, secondGeometry: Geometry) -> Void {
        do {
            if let resultGeometry = try input.intersection(with: secondGeometry) {
                geometries.append(IdentifiableGeometry(geometry: resultGeometry))
            }
        } catch {
            handleError(error)
        }
    }

    func envelope(input: Geometry) -> Void {
        do {
            let resultGeometry = try input.envelope().geometry
            geometries.append(IdentifiableGeometry(geometry: resultGeometry))
        } catch {
            handleError(error)
        }
    }
    
    func difference(input: Geometry, secondGeometry: Geometry) -> Void {
        do {
            if let resultGeometry = try input.difference(with: secondGeometry) {
                geometries.append(IdentifiableGeometry(geometry: resultGeometry))
            }
        } catch {
            handleError(error)
        }
    }
    
    func union(input: Geometry, secondGeometry: Geometry) -> Void {
        do {
            let resultGeometry = try input.union(with: secondGeometry)
            geometries.append(IdentifiableGeometry(geometry: resultGeometry))
        } catch {
            handleError(error)
        }
    }
    
    func pointOnSurface(input: Geometry) -> Void {
        do {
            let resultGeometry = try Geometry.point(input.pointOnSurface())
            geometries.append(IdentifiableGeometry(geometry: resultGeometry))
        } catch {
            handleError(error)
        }
    }
    
    func centroid(input: Geometry) -> Void {
        do {
            let resultGeometry = try Geometry.point(input.centroid())
            geometries.append(IdentifiableGeometry(geometry: resultGeometry))
        } catch {
            handleError(error)
        }
    }
    
    func boundary(input: Geometry) -> Void {
        var resultGeometry: Geometry
        do {
            switch input {
            case let .multiPoint(input):
                resultGeometry = try input.boundary()
                geometries.append(IdentifiableGeometry(geometry: resultGeometry))
            case let .polygon(input):
                resultGeometry = try input.boundary()
                geometries.append(IdentifiableGeometry(geometry: resultGeometry))
            case let .multiPolygon(input):
                resultGeometry = try input.boundary()
                geometries.append(IdentifiableGeometry(geometry: resultGeometry))
            case let .lineString(input):
                resultGeometry = try input.boundary()
                geometries.append(IdentifiableGeometry(geometry: resultGeometry))
            case let .multiLineString(input):
                resultGeometry = try input.boundary()
                geometries.append(IdentifiableGeometry(geometry: resultGeometry))
            default:
                print(input)
                print("Unable to return boundary")
            }
        } catch {
            handleError(error)
        }
    }
    
    func minimumBoundingCircle(input: Geometry) -> Void {
        do {
            let viewCircle = try input.minimumBoundingCircle()
            guard let resultGeometry = try viewCircle.center.buffer(by: viewCircle.radius) else {
                print("Unable to return bounding circle")
                hasError = true
                errorMessage = "failed to create circle"
                return
            }
            geometries.append(IdentifiableGeometry(geometry: resultGeometry))
        } catch {
            handleError(error)
        }
    }
    
    func simplify(input: Geometry) -> Void {
        do {
            let resultGeometry = try input.simplify(withTolerance: 3)
            geometries.append(IdentifiableGeometry(geometry: resultGeometry))
        } catch {
            handleError(error)
        }
    }
    
    func minimumRotatedRectangle(input: Geometry) -> Void {
        do {
            let resultGeometry = try input.minimumRotatedRectangle()
            geometries.append(IdentifiableGeometry(geometry: resultGeometry))
        } catch {
            handleError(error)
        }
    }
    
    func minimumWidth(input: Geometry) -> Void {
        do {
            let resultGeometry = try Geometry.lineString(input.minimumWidth())
            geometries.append(IdentifiableGeometry(geometry: resultGeometry))
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
               let geoJSON = try? decoder.decode(GeoJSON.self, from: data),
               case let .featureCollection(featureCollection) = geoJSON {
                let geometriesArray: [IdentifiableGeometry] = featureCollection.features.compactMap { feature in
                    guard let geometry = feature.geometry else {
                        return nil
                    }
                    return IdentifiableGeometry(geometry: geometry)
                }
                geometries = geometriesArray
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
        case GEOSwiftError.tooFewPoints:
            errorMessage = "Too few points"
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
