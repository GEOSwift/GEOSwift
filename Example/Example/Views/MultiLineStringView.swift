import Foundation
import SwiftUI
import GEOSwift

struct MultiLineStringView: View {
    var multiLineString: MultiLineString
    var gridGeometry: GeometryProxy
    var color: Color
    var selected: Bool
    
    var body: some View {
        ZStack {
            ForEach(0..<multiLineString.lineStrings.count, id: \.self) {
                LineStringView(lineString: multiLineString.lineStrings[$0], gridGeometry: gridGeometry, color: color, selected: selected)
            }
        }
    }
}
