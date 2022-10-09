import Foundation
import GEOSwift

class GeometryModel: ObservableObject {
    var baseGeometry = Data.baseGeometry
    var backupGeometry = Data.secondGeometry
    
    @Published var viewGeometry: Geometry
    @Published var viewCircle: Circle
    @Published var isCircle: Bool
    
    init (){
        viewGeometry = baseGeometry
        viewCircle = Data.baseCircle
        isCircle = false
    }
    
    func buffer(input: Geometry, bufferSize: Double = 3) -> Void {
        do {
            viewGeometry = try input.buffer(by: bufferSize)!
        } catch {
            print("Unable to buffer")
        }
        isCircle = false
    }
    
    func convexHull(input: Geometry) -> Void {
        do {
            viewGeometry = try input.convexHull()
        } catch {
            print("Unable to convex hull")
        }
        isCircle = false
    }
    
    func intersection(input: Geometry, secondGeometry: Geometry?) -> Void {
        do {
            viewGeometry = try input.intersection(with: secondGeometry ?? backupGeometry)!
        } catch {
            print("Unable to intersect")
        }
        isCircle = false
    }

    func envelope(input: Geometry) -> Void {
        do {
            viewGeometry = try input.envelope().geometry
        } catch {
            print("Unable to envelope")
        }
        isCircle = false
    }
    
    func difference(input: Geometry, secondGeometry: Geometry?) -> Void {
        do {
            viewGeometry = try input.difference(with: secondGeometry ?? backupGeometry) ?? input // TODO: Decision: throw error here?
        } catch {
            print("Unable to difference")
        }
        isCircle = false
    }
    
    func union(input: Geometry, secondGeometry: Geometry?) -> Void {
        do {
            viewGeometry = try input.union(with: secondGeometry ?? backupGeometry)
        } catch {
            print("Unable to union")
        }
        isCircle = false
    }
    
    func pointOnSurface(input: Geometry) -> Void {
        do {
            viewGeometry = try Geometry.point(input.pointOnSurface())
        } catch {
            print("Unable to return point on surface")
        }
        isCircle = false
    }
    
    func centroid(input: Geometry) -> Void {
        do {
            viewGeometry = try Geometry.point(input.centroid())
        } catch {
            print("Unable to return centroid")
        }
        isCircle = false
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
        }
        isCircle = false
    }
    
    func minimumBoundingCircle(input: Geometry) -> Void {
        do {
            viewCircle = try input.minimumBoundingCircle()
        } catch {
            print("Unable to return bounding circle")
        }
        isCircle = true
    }
}
