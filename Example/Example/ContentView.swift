import SwiftUI
import GEOSwift

struct ContentView: View {
    @State private var modifiableGeometry = GeometryModification()

    var body: some View {
        VStack {
            Text("Polygon")
                .font(.title)
                .padding()
            Path { path in
                path.move(
                    to: CGPoint(
                        x: modifiableGeometry.polygonModel.exterior.points[0].x,
                        y: modifiableGeometry.polygonModel.exterior.points[0].y
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
            List {
                Button("buffer", action: {
                    let tempGeometry = try! modifiableGeometry.polygonModel.buffer(by: 3)!
                    switch tempGeometry {
                        case let .polygon(tempGeometry):
                            modifiableGeometry.polygonModel = tempGeometry
                        default:
                            print("error")
                    }
                })
                Button("convexHull", action: {
                    let tempGeometry = try! modifiableGeometry.polygonModel.convexHull()
                    switch tempGeometry {
                        case let .polygon(tempGeometry):
                            modifiableGeometry.polygonModel = tempGeometry
                        default:
                            print("error")
                    }
                })
                Button("intersection", action: {
                    let tempGeometry = try! modifiableGeometry.polygonModel.intersection(with: modifiableGeometry.polygonModel2)!
                    switch tempGeometry {
                        case let .polygon(tempGeometry):
                            modifiableGeometry.polygonModel = tempGeometry
                        default:
                            print("error")
                    }
                })
                Button("boundary", action: {
                    let tempGeometry = try! modifiableGeometry.polygonModel.boundary()
                    switch tempGeometry {
                        case let .polygon(tempGeometry):
                            modifiableGeometry.polygonModel = tempGeometry
                        default:
                            print("error")
                    }
                })
                Button("envelope", action: {
                    let tempGeometry = try! modifiableGeometry.polygonModel.envelope().geometry
                    switch tempGeometry {
                        case let .polygon(tempGeometry):
                            modifiableGeometry.polygonModel = tempGeometry
                        default:
                            print("error")
                    }
                })
                Button("difference", action: {
                    let tempGeometry = try! modifiableGeometry.polygonModel.difference(with: modifiableGeometry.polygonModel2)!
                    switch tempGeometry {
                        case let .polygon(tempGeometry):
                            modifiableGeometry.polygonModel = tempGeometry
                        default:
                            print("error")
                    }
                })
                Button("union", action: {
                    let tempGeometry = try! modifiableGeometry.polygonModel.union(with: modifiableGeometry.polygonModel2)
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
