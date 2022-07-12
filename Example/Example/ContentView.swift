import SwiftUI
import GEOSwift

struct ContentView: View {
    var point = try! Point(wkt: "POINT(10 45)")
    var polygon = try! Polygon(wkt: "POLYGON((50 50, 300 21, 120 200, 30 150, 50 50))")
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
                    polygon.exterior.points.forEach { point in
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
                Text("buffer")
                Text("convexHull")
                Text("intersection")
                Text("boundary")
                Text("envelope")
                Text("difference")
                Text("centroid")
                Text("pointOnSurface")
                Text("union")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
