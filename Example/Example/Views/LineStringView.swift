import Foundation
import SwiftUI
import GEOSwift

struct LineStringView: View {
    var identifiableLineString: IdentifiableLineString
    var gridGeometry: GeometryProxy
    
    var body: some View {
        let height = gridGeometry.size.height
        
        ZStack {
            Path { path in
                path.move(
                    to: CGPoint(
                        x: identifiableLineString.lineString.points[0].x,
                        y: height - identifiableLineString.lineString.points[0].y
                    )
                )
                identifiableLineString.lineString.points.forEach { point in
                    path.addLine(
                        to: CGPoint(
                            x: point.x,
                            y: height - point.y
                        )
                    )
                }
            }
            .stroke(lineWidth: 2)
        }
    }
}
