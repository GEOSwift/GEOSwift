import Foundation
import SwiftUI
import GEOSwift

struct MultiPointView: View {
    var multiPoint: MultiPoint
    var body: some View {
        ZStack {
            ForEach(0..<multiPoint.points.count, id: \.self) {
                PointView(point: multiPoint.points[$0])
            }
        }
    }
}
