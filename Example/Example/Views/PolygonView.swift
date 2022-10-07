import Foundation
import SwiftUI
import GEOSwift

struct PolygonView: View {
    var polygon: Polygon
    var body: some View {
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
            } // TODO: Interior polygons
        }
        .foregroundColor(.pink)
        .opacity(0.3)
    }
}
