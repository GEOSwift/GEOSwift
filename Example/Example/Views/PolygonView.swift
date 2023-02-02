import Foundation
import SwiftUI
import GEOSwift

struct PolygonView: View {
    var polygon: Polygon
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                let origin = CGPoint(x: 0, y: height)
                var pointsToLabel = [Point]()
                
                ZStack {
                    Path { path in
                        path.move(
                            to: CGPoint(
                                x: polygon.exterior.points[0].x,
                                y: origin.y-polygon.exterior.points[0].y
                            )
                        )
                        polygon.exterior.points.forEach { point in
                            path.addLine(
                                to: CGPoint(
                                    x: point.x,
                                    y: origin.y-point.y
                                )
                            )
                            pointsToLabel.append(point)
                        }
                    }
                    .foregroundColor(.pink)
                    .opacity(0.3)
                    Path { path in
                        polygon.holes.forEach{ hole in
                            path.move(
                                to: CGPoint(
                                    x: hole.points[0].x,
                                    y: origin.y - hole.points[0].y
                                )
                            )
                            hole.points.forEach { point in
                                path.addLine(
                                    to: CGPoint(
                                        x: point.x,
                                        y: origin.y - point.y
                                    )
                                )
                                pointsToLabel.append(point)
                            }
                        }
                    }
                    .foregroundColor(.black)
                    ForEach(pointsToLabel, id: \.self) { point in
                        Text("(\(String(point.x.rounded())), \(String(point.y.rounded())))").position(x: point.x + 38, y: origin.y - point.y - 15)
                    }
                }
            }
        }
    }
}

struct PolygonView_Previews: PreviewProvider {
    static var previews: some View {
        PolygonView(polygon: try! Polygon(wkt: "POLYGON((50 50, 300 121, 120 200, 30 150, 50 50))"))
    }
}
