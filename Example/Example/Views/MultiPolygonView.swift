import Foundation
import SwiftUI
import GEOSwift

struct MultiPolygonView: View {
    var multiPolygon: MultiPolygon
    var body: some View {
        ZStack {
            ForEach(0..<multiPolygon.polygons.count, id: \.self) {
                PolygonView(polygon: multiPolygon.polygons[$0])
            }
        }
    }
}
