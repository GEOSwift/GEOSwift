import Foundation
import SwiftUI
import GEOSwift

struct LineStringView: View {
    var lineString: LineString
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let origin = CGPoint(x: 0, y: height)
            Path { path in
                path.move(
                    to: CGPoint(
                        x: lineString.points[0].x,
                        y: origin.y - lineString.points[0].y
                    )
                )
                lineString.points.forEach { point in
                    path.addLine(
                        to: CGPoint(
                            x: point.x,
                            y: origin.y - point.y
                        )
                    )
                }
            }
            .stroke(lineWidth: 2)
            .opacity(0.3)
        }
    }
}
