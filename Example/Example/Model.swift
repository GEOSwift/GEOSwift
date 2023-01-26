import Foundation
import GEOSwift

class GeometryModel: ObservableObject {
    var backupGeometry = GeoData.secondGeometry
    
    @Published var geometries: [Geometry]
    @Published var hasError: Bool
    @Published var errorMessage: String
    
    init (){
        geometries = [backupGeometry]
        hasError = false
        errorMessage = ""
    }

    func buffer(input: Geometry, bufferSize: Double = 3) -> Void {
        do {
            let resultGeometry = try input.buffer(by: bufferSize)!
            geometries = [input, resultGeometry]
        } catch {
            print("Unable to buffer")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func convexHull(input: Geometry) -> Void {
        do {
            let resultGeometry = try input.convexHull()
            geometries = [input, resultGeometry]
        } catch {
            print("Unable to convex hull")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func intersection(input: Geometry, secondGeometry: Geometry?) -> Void {
        do {
            let resultGeometry = try input.intersection(with: secondGeometry ?? backupGeometry)!
            geometries = [input, secondGeometry ?? backupGeometry, resultGeometry]
        } catch {
            print("Unable to intersect")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }

    func envelope(input: Geometry) -> Void {
        do {
            let resultGeometry = try input.envelope().geometry
            geometries = [input, resultGeometry]
        } catch {
            print("Unable to envelope")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func difference(input: Geometry, secondGeometry: Geometry?) -> Void {
        do {
            let resultGeometry = try input.difference(with: secondGeometry ?? backupGeometry) ?? input // TODO: Decision: throw error here?
            geometries = [input, secondGeometry ?? backupGeometry, resultGeometry]
        } catch {
            print("Unable to difference")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func union(input: Geometry, secondGeometry: Geometry?) -> Void {
        do {
            let resultGeometry = try input.union(with: secondGeometry ?? backupGeometry)
            geometries = [input, secondGeometry ?? backupGeometry, resultGeometry]
        } catch {
            print("Unable to union")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func pointOnSurface(input: Geometry) -> Void {
        do {
            let resultGeometry = try Geometry.point(input.pointOnSurface())
            geometries = [input, resultGeometry]
        } catch {
            print("Unable to return point on surface")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func centroid(input: Geometry) -> Void {
        do {
            let resultGeometry = try Geometry.point(input.centroid())
            geometries = [input, resultGeometry]
        } catch {
            print("Unable to return centroid")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func boundary(input: Geometry) -> Void {
        var resultGeometry: Geometry?
        do {
            switch input {
            case let .multiPoint(input):
                resultGeometry = try input.boundary()
            case let .polygon(input):
                resultGeometry = try input.boundary()
            case let .multiPolygon(input):
                resultGeometry = try input.boundary()
            case let .lineString(input):
                resultGeometry = try input.boundary()
            case let .multiLineString(input):
                resultGeometry = try input.boundary()
            default:
                print(input)
                print("Unable to return boundary")
            }
            if resultGeometry != nil {
                geometries = [input, resultGeometry!]
            }
        } catch {
            print("Unable to return boundary")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func minimumBoundingCircle(input: Geometry) -> Void {
        do {
            var viewCircle = try input.minimumBoundingCircle()
            guard let resultGeometry = try viewCircle.center.buffer(by: viewCircle.radius) else {
                print("Unable to return bounding circle")
                hasError = true
                errorMessage = "failed to create circle"
                return
            }
            geometries = [input, resultGeometry]
        } catch {
            print("Unable to return bounding circle")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func simplify(input: Geometry) -> Void {
        do {
            let resultGeometry = try input.simplify(withTolerance: 3)
            geometries = [input, resultGeometry]
        } catch {
            print("Unable to simplify")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func minimumRotatedRectangle(input: Geometry) -> Void {
        do {
            let resultGeometry = try input.minimumRotatedRectangle()
            geometries = [input, resultGeometry]
        } catch {
            print("Unable to return minimum rotated rectange")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func minimumWidth(input: Geometry) -> Void {
        do {
            let resultGeometry = try Geometry.lineString(input.minimumWidth())
            geometries = [input, resultGeometry]
        } catch {
            print("Unable to return minimum width")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func clear() {
        geometries = []
    }
    
    func importGeometry(_ result: Result<URL, Error>) {
        do {
            let selectedFile: URL = try result.get()
            _ = selectedFile.startAccessingSecurityScopedResource()
            let decoder = JSONDecoder()
            if let data = try? Data(contentsOf: selectedFile),
               let geoJSON = try? decoder.decode(GeoJSON.self, from: data),
               case let .featureCollection(featureCollection) = geoJSON {
                let geometriesArray = featureCollection.features.compactMap { feature in
                    feature.geometry
                }
                geometries = geometriesArray
            }
            selectedFile.stopAccessingSecurityScopedResource()
        } catch {
            print(error)
            // Handle failure
        }
    }
}
