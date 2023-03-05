import Foundation
import SwiftUI
import GEOSwift

struct MultiLineStringView: View {
    var multiLineString: IdentifiableMultiLineString
    var gridGeometry: GeometryProxy
    var color: Color
    var selected: Bool
    
    var body: some View {
        ZStack {
            ForEach(multiLineString.lineStrings, id: \.id) { lineString in
                LineStringView(lineString: lineString, gridGeometry: gridGeometry, color: color, selected: selected)
            }
        }
    }
}
