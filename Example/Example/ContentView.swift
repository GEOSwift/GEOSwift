import SwiftUI
import GEOSwift

struct ContentView: View {
    @ObservedObject private var geometryModel = GeometryModel()
    
    var body: some View {
        VStack {
            Text("Geometry")
                .font(.title)
                .padding()
            if geometryModel.isCircle {
                ShapeView(shape: .circle(geometryModel.viewCircle))
            } else {
                ShapeView(shape: .geometry(geometryModel.viewGeometry))
            }
            List {
                Button("point", action: {
                    geometryModel.viewGeometry = .point(Point(x: 3, y: 4))
                })
                Button("multiPoint", action: {
                    geometryModel.viewGeometry = .multiPoint(MultiPoint(
                        points: [
                            Point(x: 5, y: 9),
                            Point(x: 90, y: 32),
                            Point(x: 59, y: 89)]))
                })
                Button("polygon", action: {
                    geometryModel.viewGeometry = .polygon(try! Polygon(exterior: Polygon.LinearRing(points: [
                        Point(x: 5, y: 9),
                        Point(x: 90, y: 32),
                        Point(x: 59, y: 89),
                        Point(x: 5, y: 9)])
                    ))
                })
                Button("multiPolygon", action: {
                    geometryModel.viewGeometry = .multiPolygon(MultiPolygon(polygons:
                        [try! Polygon(exterior: Polygon.LinearRing(points: [
                            Point(x: 5, y: 9),
                            Point(x: 90, y: 32),
                            Point(x: 59, y: 89),
                            Point(x: 5, y: 9)])
                        ),
                         try! Polygon(exterior: Polygon.LinearRing(points: [
                            Point(x: 25, y: 29),
                            Point(x: 20, y: 22),
                            Point(x: 29, y: 89),
                            Point(x: 25, y: 29)])
                         )]))
                })
                Button("lineString", action: {
                    geometryModel.viewGeometry = .lineString(try! LineString(points: [
                        Point(x: 5, y: 9),
                        Point(x: 90, y: 32),
                        Point(x: 59, y: 89),
                        Point(x: 5, y: 9)]))
                })
                Button("multiLineString", action: {
                    geometryModel.viewGeometry = .multiLineString(MultiLineString(lineStrings:
                        [try! LineString(points: [
                            Point(x: 5, y: 9),
                            Point(x: 90, y: 32),
                            Point(x: 59, y: 89),
                            Point(x: 5, y: 9)]),
                         try! LineString(points: [
                            Point(x: 25, y: 29),
                            Point(x: 20, y: 22),
                            Point(x: 29, y: 89),
                            Point(x: 25, y: 29)])
                        ]))
                })
//                Button("buffer", action: {
//                    geometryModel.buffer(input: geometryModel.viewGeometry)
//                })
//                Button("convexHull", action: {
//                    geometryModel.convexHull(input: geometryModel.viewGeometry)
//                })
//                Button("intersection", action: {
//                    geometryModel.intersection(input: geometryModel.viewGeometry, secondGeometry: nil)
//                })
//                Button("boundary", action: {
//                    geometryModel.boundary(input: geometryModel.viewGeometry)
//                })
                // TODO: List only allows 10 Buttons (?), come up with better input system
//                Button("envelope", action: {
//                    geometryModel.envelope(input: geometryModel.viewGeometry)
//                })
//                Button("difference", action: {
//                    geometryModel.difference(input: geometryModel.viewGeometry, secondGeometry: nil)
//                })
//                Button("union", action: {
//                    geometryModel.union(input: geometryModel.viewGeometry, secondGeometry: nil)
//                })
//                Button("point on surface", action: {
//                    geometryModel.pointOnSurface(input: geometryModel.viewGeometry)
//                })
//                Button("centroid", action: {
//                    geometryModel.centroid(input: geometryModel.viewGeometry)
//                })
                Button("minimum bounding circle", action: {
                    geometryModel.minimumBoundingCircle(input: geometryModel.viewGeometry)
                })
                Button("minimum rotated rectange", action: { geometryModel.minimumRotatedRectangle(input: geometryModel.viewGeometry)
                })
                Button("simplify", action: {
                    geometryModel.simplify(input: geometryModel.viewGeometry)
                })
                Button("minimum Width", action: {
                    geometryModel.minimumWidth(input: geometryModel.viewGeometry)
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
