import SwiftUI
import GEOSwift

struct ContentView: View {
    @ObservedObject private var geometryModel = GeometryModel()
    @State private var index = 0
    
    var body: some View {
        
        VStack {
            Text("Geometry")
                .font(.title)
                .padding()
            VStack{
                TabView(selection: $index) {
                    ForEach((0..<geometryModel.geometries.count), id: \.self) { index in
                        GeometryView(geometry: geometryModel.geometries[index])
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                HStack(spacing: 2) {
                    ForEach((0..<geometryModel.geometries.count), id: \.self) { index in
                        Rectangle()
                            .fill(index == self.index ? Color.purple : Color.purple.opacity(0.5))
                            .frame(height: 5)
                    }
                }
                .padding()
            }
            List {
                Group {
                    Button("buffer", action: {
                        geometryModel.buffer(input: geometryModel.resultGeometry)
                    })
                    Button("convexHull", action: {
                        geometryModel.convexHull(input: geometryModel.resultGeometry)
                    })
                    Button("intersection", action: {
                        geometryModel.intersection(input: geometryModel.resultGeometry, secondGeometry: nil)
                    })
                    Button("boundary", action: {
                        geometryModel.boundary(input: geometryModel.resultGeometry)
                    })
                    Button("envelope", action: {
                        geometryModel.envelope(input: geometryModel.resultGeometry)
                    })
                    Button("difference", action: {
                        geometryModel.difference(input: geometryModel.resultGeometry, secondGeometry: nil)
                    })
                    Button("union", action: {
                        geometryModel.union(input: geometryModel.resultGeometry, secondGeometry: nil)
                    })
                    Button("point on surface", action: {
                        geometryModel.pointOnSurface(input: geometryModel.resultGeometry)
                    })
                    Button("centroid", action: {
                        geometryModel.centroid(input: geometryModel.resultGeometry)
                    })
                    Button("minimum bounding circle", action: {
                        geometryModel.minimumBoundingCircle(input: geometryModel.resultGeometry)
                    })

                }
                Group {
                    Button("minimum rotated rectange", action: { geometryModel.minimumRotatedRectangle(input: geometryModel.resultGeometry)
                    })
                    Button("simplify", action: {
                        geometryModel.simplify(input: geometryModel.resultGeometry)
                    })
                    Button("minimum Width", action: {
                        geometryModel.minimumWidth(input: geometryModel.resultGeometry)
                    })
                }
                // Temp geometries 
                Group {
                    Button("point", action: {
                        geometryModel.resultGeometry = .point(Point(x: 3, y: 4))
                        geometryModel.geometries = [geometryModel.resultGeometry]
                    })
                    Button("multiPoint", action: {
                        geometryModel.resultGeometry = .multiPoint(MultiPoint(
                            points: [
                                Point(x: 5, y: 9),
                                Point(x: 90, y: 32),
                                Point(x: 59, y: 89)]))
                        geometryModel.geometries = [geometryModel.resultGeometry]
                    })
                    Button("polygon", action: {
                        geometryModel.resultGeometry = .polygon(try! Polygon(exterior: Polygon.LinearRing(points: [
                            Point(x: 5, y: 9),
                            Point(x: 90, y: 32),
                            Point(x: 59, y: 89),
                            Point(x: 5, y: 9)])
                        ))
                        geometryModel.geometries = [geometryModel.resultGeometry]
                    })
                    Button("multiPolygon", action: {
                        geometryModel.resultGeometry = .multiPolygon(MultiPolygon(polygons:
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
                        geometryModel.geometries = [geometryModel.resultGeometry]
                    })
                    Button("lineString", action: {
                        geometryModel.resultGeometry = .lineString(try! LineString(points: [
                            Point(x: 5, y: 9),
                            Point(x: 90, y: 32),
                            Point(x: 59, y: 89),
                            Point(x: 5, y: 9)]))
                        geometryModel.geometries = [geometryModel.resultGeometry]
                    })
                    Button("multiLineString", action: {
                        geometryModel.resultGeometry = .multiLineString(MultiLineString(lineStrings:
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
                        geometryModel.geometries = [geometryModel.resultGeometry]
                    })
                }
            }
        }
        .alert("Geometry Error: " + geometryModel.errorMessage, isPresented: $geometryModel.hasError) {
            Button("Try again", role: .cancel) {
                
            }
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
