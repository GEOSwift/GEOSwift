import Foundation
import SwiftUI
import GEOSwift

struct PolygonView: View {
    var polygon: Polygon
    var body: some View {
        ZStack {
            Path { path in
                path.move(
                    to: CGPoint(
                        x: polygon.exterior.points[0].x,
                        y: polygon.exterior.points[0].y
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
            .foregroundColor(.pink)
            .opacity(0.3)
            Path { path in
                polygon.holes.forEach{ hole in
                    path.move(
                        to: CGPoint(
                            x: hole.points[0].x,
                            y: hole.points[0].y
                        )
                    )
                    hole.points.forEach { point in
                        path.addLine(
                            to: CGPoint(
                                x: point.x,
                                y: point.y
                            )
                        )
                    }
                }
            }
            .foregroundColor(.black)
        }
    }
}

struct PolygonView_Previews: PreviewProvider {
    static var previews: some View {

        PolygonView(polygon: try! Polygon(wkt: "POLYGON((50 50, 300 121, 120 200, 30 150, 50 50))"))
    }
}
