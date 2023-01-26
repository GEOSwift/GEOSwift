import SwiftUI
import GEOSwift
import UniformTypeIdentifiers
import Foundation


struct ContentView: View {
    @ObservedObject private var geometryModel = GeometryModel()
    @State private var index = 0
    @State private var isImporting: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button("New", action: { isImporting = true })
                    .font(.system(.headline))
                Text("Geometry")
                    .font(.title)
                    .padding()
                Button("Clear", action: { geometryModel.clear() })
                    .font(.system(.headline))
            }
            .fileImporter(isPresented: $isImporting,
                          allowedContentTypes: [.json]) { result in
                geometryModel.importGeometry(result)
            }
            VStack{
                TabView(selection: $index) {
                    ForEach((0..<geometryModel.geometries.count), id: \.self) { index in
                        GeometryView(geometry: geometryModel.geometries[index])
                    }
                    .border(.gray, width: 1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                HStack(spacing: 2) {
                    ForEach((0..<geometryModel.geometries.count), id: \.self) { index in
                        VStack {
                            Rectangle()
                                .fill(index == self.index ? Color.purple : Color.purple.opacity(0.5))
                            .frame(height: 5)
                            Text(String(index))
                                .foregroundColor(Color.purple)
                        }
                        .onTapGesture {
                            self.index = index
                        }
                    }
                }
                .padding()
            }
            List {
                Group {
                    Button("buffer", action: {
                        geometryModel.buffer(input: geometryModel.geometries[index])
                    })
                    Button("convexHull", action: {
                        geometryModel.convexHull(input: geometryModel.geometries[index])
                    })
                    Button("intersection", action: {
                        geometryModel.intersection(input: geometryModel.geometries[index], secondGeometry: nil)
                    })
                    Button("boundary", action: {
                        geometryModel.boundary(input: geometryModel.geometries[index])
                    })
                    Button("envelope", action: {
                        geometryModel.envelope(input: geometryModel.geometries[index])
                    })
                    Button("difference", action: {
                        geometryModel.difference(input: geometryModel.geometries[index], secondGeometry: nil)
                    })
                    Button("union", action: {
                        geometryModel.union(input: geometryModel.geometries[index], secondGeometry: nil)
                    })
                    Button("point on surface", action: {
                        geometryModel.pointOnSurface(input: geometryModel.geometries[index])
                    })
                    Button("centroid", action: {
                        geometryModel.centroid(input: geometryModel.geometries[index])
                    })
                    Button("minimum bounding circle", action: {
                        geometryModel.minimumBoundingCircle(input: geometryModel.geometries[index])
                    })
                }
                Group {
                    Button("minimum rotated rectange", action: { geometryModel.minimumRotatedRectangle(input: geometryModel.geometries[index])
                    })
                    Button("simplify", action: {
                        geometryModel.simplify(input: geometryModel.geometries[index])
                    })
                    Button("minimum Width", action: {
                        geometryModel.minimumWidth(input: geometryModel.geometries[index])
                    })
                }
                // Sample geometries
                Group {
                    Button("point", action: {
                        geometryModel.geometries = [.point(Point(x: 3, y: 4))]
                    })
                    Button("multiPoint", action: {
                        geometryModel.geometries = [.multiPoint(MultiPoint(
                            points: [
                                Point(x: 5, y: 9),
                                Point(x: 90, y: 32),
                                Point(x: 59, y: 89)]))]
                    })
                    Button("polygon", action: {
                        geometryModel.geometries = [.polygon(try! Polygon(exterior: Polygon.LinearRing(points: [
                            Point(x: 5, y: 9),
                            Point(x: 90, y: 32),
                            Point(x: 59, y: 89),
                            Point(x: 5, y: 9)])
                        ))]
                    })
                    Button("multiPolygon", action: {
                        geometryModel.geometries = [.multiPolygon(MultiPolygon(polygons:
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
                             )]))]
                    })
                    Button("lineString", action: {
                        geometryModel.geometries = [.lineString(try! LineString(points: [
                            Point(x: 5, y: 9),
                            Point(x: 90, y: 32),
                            Point(x: 59, y: 89),
                            Point(x: 5, y: 9)]))]
                    })
                    Button("multiLineString", action: {
                        geometryModel.geometries = [.multiLineString(MultiLineString(lineStrings:
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
                            ]))]
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
