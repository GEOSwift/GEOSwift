import Foundation
import GEOSwift

class GeometryModel: ObservableObject {
    var baseGeometry = Data.baseGeometry
    var backupGeometry = Data.secondGeometry
    
    @Published var viewGeometry: Geometry
    
    init (){
        viewGeometry = baseGeometry
    }
    
    func buffer(input: Geometry, bufferSize: Double = 3) -> Void {
        var temp = input
        do {
            temp = try input.buffer(by: bufferSize)!
        } catch {
            print("Unable to buffer")
        }
        viewGeometry = temp
    }
    
    func convexHull(input: Geometry) -> Void {
        var temp = input
        do {
            temp = try input.convexHull()
        } catch {
            print("Unable to convex hull")
        }
        viewGeometry = temp
    }
    
    func intersection(input: Geometry, secondGeometry: Geometry?) -> Void {
        var temp = input
        do {
            temp = try input.intersection(with: secondGeometry ?? backupGeometry)!
        } catch {
            print("Unable to intersect")
        }
        viewGeometry = temp
    }

    func envelope(input: Geometry) -> Void {
        var temp = input
        do {
            temp = try input.envelope().geometry
        } catch {
            print("Unable to envelope")
        }
        viewGeometry = temp
    }
    
    func difference(input: Geometry, secondGeometry: Geometry?) -> Void {
        var temp = input
        do {
            temp = try input.difference(with: secondGeometry ?? backupGeometry) ?? input // TODO: Decision: throw error here?
        } catch {
            print("Unable to difference")
        }
        viewGeometry = temp
    }
    
    func union(input: Geometry, secondGeometry: Geometry?) -> Void {
        var temp = input
        do {
            temp = try input.union(with: secondGeometry ?? backupGeometry)
        } catch {
            print("Unable to union")
        }
        viewGeometry = temp
    }
    
    func pointOnSurface(input: Geometry) -> Void {
        var temp = input
        do {
            temp = try Geometry.point(input.pointOnSurface())
        } catch {
            print("Unable to return point on surface")
        }
        viewGeometry = temp
    }
    
    func boundary(input: Geometry) -> Void {
        var temp = input
        do {
            switch input {
            case let .multiPoint(input):
                temp = try input.boundary()
            case let .polygon(input):
                temp = try input.boundary()
            case let .multiPolygon(input):
                temp = try input.boundary()
            case let .lineString(input):
                temp = try input.boundary()
            case let .multiLineString(input):
                temp = try input.boundary()
            default:
                print(input)
                print("Unable to return boundary")
            }
        } catch {
            print("catch")
            print(input)
            print("Unable to return boundary")
        }
        viewGeometry = temp
    }
}
