import Foundation
import SwiftUI
import GEOSwift

struct PointView: View {
    var point: Point
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(
                    to: CGPoint(
                        x: point.x,
                        y: point.y
                    )
                )
                path.addEllipse(in: CGRect(x: point.x - 8, y: point.y - 8, width: 16, height: 16))
            }
            .foregroundColor(.pink)
            .opacity(0.3)
        }
    }
}
