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
                Button("Add \n Geometry", action: { isImporting = true })
                    .font(.system(.headline))
                Text("Geometry")
                    .font(.title)
                    .padding()
            }
            .fileImporter(isPresented: $isImporting,
                          allowedContentTypes: [.json]) { result in
                do {
                    let selectedFile: URL = try result.get()
                    let isAccess = selectedFile.startAccessingSecurityScopedResource()
                    let decoder = JSONDecoder()
                    do {
                        let data = try Data(contentsOf: selectedFile)
                        let geoJSON = try decoder.decode(GeoJSON.self, from: data)
                        if case let .feature(feature) = geoJSON,
                           let geom = feature.geometry {
                            geometryModel.resultGeometry = geom
                            geometryModel.geometries = [geometryModel.resultGeometry]
                        }
//                        if isAccess {
//                            selectedFile.stopAccessingSecurityScopedResource()
//                        }
                    } catch {
                        print(error)
                    }
                } catch {
                    // Handle failure.
                }
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
                            Text(index == geometryModel.geometries.count - 1 ? "Output" : "Input")
                                .foregroundColor(Color.purple)
                        }
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
