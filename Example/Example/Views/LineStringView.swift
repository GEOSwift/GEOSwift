import Foundation
import SwiftUI
import GEOSwift

struct LineStringView: View {
    var lineString: LineString
    var body: some View {
        Path { path in
            path.move(
                to: CGPoint(
                    x: lineString.points[0].x,
                    y: lineString.points[0].y
                )
            )
            lineString.points.forEach { point in
                path.addLine(
                    to: CGPoint(
                        x: point.x,
                        y: point.y
                    )
                )
            }
        }
        .stroke(lineWidth: 2)
        .opacity(0.3)
    }
}
