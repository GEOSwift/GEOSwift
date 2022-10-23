import Foundation
import GEOSwift

class GeometryModel: ObservableObject {
    var baseGeometry = Data.baseGeometry
    var backupGeometry = Data.secondGeometry
    
    @Published var viewGeometry: Geometry
    @Published var viewCircle: Circle
    @Published var viewPolygon: Polygon
    @Published var hasError: Bool
    @Published var errorMessage: String
    
    init (){
        viewGeometry = baseGeometry
        viewCircle = Data.baseCircle
        viewPolygon = Data.polygon
        hasError = false
        errorMessage = ""
    }

    func buffer(input: Geometry, bufferSize: Double = 3) -> Void {
        do {
            viewGeometry = try input.buffer(by: bufferSize)!
        } catch {
            print("Unable to buffer")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func convexHull(input: Geometry) -> Void {
        do {
            viewGeometry = try input.convexHull()
        } catch {
            print("Unable to convex hull")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func intersection(input: Geometry, secondGeometry: Geometry?) -> Void {
        do {
            viewGeometry = try input.intersection(with: secondGeometry ?? backupGeometry)!
        } catch {
            print("Unable to intersect")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }

    func envelope(input: Geometry) -> Void {
        do {
            viewGeometry = try input.envelope().geometry
        } catch {
            print("Unable to envelope")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func difference(input: Geometry, secondGeometry: Geometry?) -> Void {
        do {
            viewGeometry = try input.difference(with: secondGeometry ?? backupGeometry) ?? input // TODO: Decision: throw error here?
        } catch {
            print("Unable to difference")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func union(input: Geometry, secondGeometry: Geometry?) -> Void {
        do {
            viewGeometry = try input.union(with: secondGeometry ?? backupGeometry)
        } catch {
            print("Unable to union")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func pointOnSurface(input: Geometry) -> Void {
        do {
            viewGeometry = try Geometry.point(input.pointOnSurface())
        } catch {
            print("Unable to return point on surface")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func centroid(input: Geometry) -> Void {
        do {
            viewGeometry = try Geometry.point(input.centroid())
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
                viewGeometry = try input.boundary()
            case let .polygon(input):
                viewGeometry = try input.boundary()
            case let .multiPolygon(input):
                viewGeometry = try input.boundary()
            case let .lineString(input):
                viewGeometry = try input.boundary()
            case let .multiLineString(input):
                viewGeometry = try input.boundary()
            default:
                print(input)
                print("Unable to return boundary")
            }
        } catch {
            print("Unable to return boundary")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func minimumBoundingCircle(input: Geometry) -> Void {
        do {
            viewCircle = try input.minimumBoundingCircle()
            guard (try viewCircle.center.buffer(by: viewCircle.radius)) != nil else {
                print("Unable to return bounding circle")
                hasError = true
                errorMessage = "failed to create circle"
                return
            }
        } catch {
            print("Unable to return bounding circle")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func simplify(input: Geometry) -> Void {
        do {
            viewGeometry = try input.simplify(withTolerance: 3)
        } catch {
            print("Unable to simplify")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func minimumRotatedRectangle(input: Geometry) -> Void {
        do {
            viewGeometry = try input.minimumRotatedRectangle()
        } catch {
            print("Unable to return minimum rotated rectange")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
    
    func minimumWidth(input: Geometry) -> Void {
        do {
            viewGeometry = try Geometry.lineString(input.minimumWidth())
        } catch {
            print("Unable to return minimum width")
            hasError = true
            errorMessage = error.localizedDescription
        }
    }
}
