import Foundation
import GEOSwift

class GeometryModel: ObservableObject {
    var baseGeometry = GeoData.baseGeometry
    var backupGeometry = GeoData.secondGeometry
    
    @Published var geometries: [Geometry]
    @Published var secondGeometry: Geometry
    @Published var resultGeometry: Geometry
    @Published var viewCircle: Circle
    @Published var viewPolygon: Polygon
    @Published var hasError: Bool
    @Published var errorMessage: String
    
    init (){
        secondGeometry = backupGeometry
        resultGeometry = baseGeometry
        geometries = [baseGeometry]
        viewCircle = GeoData.baseCircle
        viewPolygon = GeoData.polygon
        hasError = false
        errorMessage = ""
    }

    func buffer(input: Geometry, bufferSize: Double = 3) -> Void {
        do {
            resultGeometry = try input.buffer(by: bufferSize)!
            geometries = [input, resultGeometry]
        } catch {
            print("Unable to buffer")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func convexHull(input: Geometry) -> Void {
        do {
            resultGeometry = try input.convexHull()
            geometries = [input, resultGeometry]
        } catch {
            print("Unable to convex hull")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func intersection(input: Geometry, secondGeometry: Geometry?) -> Void {
        do {
            resultGeometry = try input.intersection(with: secondGeometry ?? backupGeometry)!
            geometries = [input, secondGeometry ?? backupGeometry, resultGeometry]
        } catch {
            print("Unable to intersect")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }

    func envelope(input: Geometry) -> Void {
        do {
            resultGeometry = try input.envelope().geometry
            geometries = [input, resultGeometry]
        } catch {
            print("Unable to envelope")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func difference(input: Geometry, secondGeometry: Geometry?) -> Void {
        do {
            resultGeometry = try input.difference(with: secondGeometry ?? backupGeometry) ?? input // TODO: Decision: throw error here?
            geometries = [input, secondGeometry ?? backupGeometry, resultGeometry]
        } catch {
            print("Unable to difference")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func union(input: Geometry, secondGeometry: Geometry?) -> Void {
        do {
            resultGeometry = try input.union(with: secondGeometry ?? backupGeometry)
            geometries = [input, secondGeometry ?? backupGeometry, resultGeometry]
        } catch {
            print("Unable to union")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func pointOnSurface(input: Geometry) -> Void {
        do {
            resultGeometry = try Geometry.point(input.pointOnSurface())
            geometries = [input, resultGeometry]
        } catch {
            print("Unable to return point on surface")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func centroid(input: Geometry) -> Void {
        do {
            resultGeometry = try Geometry.point(input.centroid())
            geometries = [input, resultGeometry]
        } catch {
            print("Unable to return centroid")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func boundary(input: Geometry) -> Void {
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
            geometries = [input, resultGeometry]
        } catch {
            print("Unable to return boundary")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func minimumBoundingCircle(input: Geometry) -> Void {
        do {
            viewCircle = try input.minimumBoundingCircle()
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
            resultGeometry = try input.simplify(withTolerance: 3)
            geometries = [input, resultGeometry]
        } catch {
            print("Unable to simplify")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func minimumRotatedRectangle(input: Geometry) -> Void {
        do {
            resultGeometry = try input.minimumRotatedRectangle()
            geometries = [input, resultGeometry]
        } catch {
            print("Unable to return minimum rotated rectange")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func minimumWidth(input: Geometry) -> Void {
        do {
            resultGeometry = try Geometry.lineString(input.minimumWidth())
            geometries = [input, resultGeometry]
        } catch {
            print("Unable to return minimum width")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func resetGeometry(input: Geometry) -> Void {
        
    }
}
