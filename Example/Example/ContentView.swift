import SwiftUI
import GEOSwift

struct ContentView: View {
    @State private var modifiableGeometry = GeometryModification()
    @State private var tempGeometry = try! Geometry(wkt: "POLYGON((35 10, 45 45.5, 15 40, 10 20, 35 10),(20 30, 35 35, 30 20, 20 30))")
    var body: some View {
        VStack {
            Text("Polygon")
                .font(.title)
                .padding()
            GeometryReader { geometry in
                Path { path in
                    path.move(
                        to: CGPoint(
                            x: 0.0,
                            y: 0.0
                        )
                    )
                    modifiableGeometry.polygonModel.exterior.points.forEach { point in
                        path.addLine(
                            to: CGPoint(
                                x: point.x,
                                y: point.y
                            )
                        )
                    }
                }
                .foregroundColor(.blue)
                .opacity(0.5)
            }
            List {
                Button("buffer", action: {
                    tempGeometry = try! modifiableGeometry.polygonModel.buffer(by: 3)!
                    switch tempGeometry {
                        case let .polygon(tempGeometry):
                            modifiableGeometry.polygonModel = tempGeometry
                        default:
                            print("error")
                    }
                })
                Button("convexHull", action: {
                    tempGeometry = try! modifiableGeometry.polygonModel.convexHull()
                    switch tempGeometry {
                        case let .polygon(tempGeometry):
                            modifiableGeometry.polygonModel = tempGeometry
                        default:
                            print("error")
                    }
                })
                Button("intersection", action: {
                    tempGeometry = try! modifiableGeometry.polygonModel.intersection(with: modifiableGeometry.polygonModel2)!
                    switch tempGeometry {
                        case let .polygon(tempGeometry):
                            modifiableGeometry.polygonModel = tempGeometry
                        default:
                            print("error")
                    }
                })
                Button("boundary", action: {
                    tempGeometry = try! modifiableGeometry.polygonModel.boundary()
                    switch tempGeometry {
                        case let .polygon(tempGeometry):
                            modifiableGeometry.polygonModel = tempGeometry
                        default:
                            print("error")
                    }
                })
                Button("envelope", action: {
                    tempGeometry = try! modifiableGeometry.polygonModel.envelope().geometry
                    switch tempGeometry {
                        case let .polygon(tempGeometry):
                            modifiableGeometry.polygonModel = tempGeometry
                        default:
                            print("error")
                    }
                })
                Button("difference", action: {
                    tempGeometry = try! modifiableGeometry.polygonModel.difference(with: modifiableGeometry.polygonModel2)!
                    switch tempGeometry {
                        case let .polygon(tempGeometry):
                            modifiableGeometry.polygonModel = tempGeometry
                        default:
                            print("error")
                    }
                })
                Button("union", action: {
                    tempGeometry = try! modifiableGeometry.polygonModel.union(with: modifiableGeometry.polygonModel2)
                    switch tempGeometry {
                        case let .polygon(tempGeometry):
                            modifiableGeometry.polygonModel = tempGeometry
                        default:
                            print("error")
                    }
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
