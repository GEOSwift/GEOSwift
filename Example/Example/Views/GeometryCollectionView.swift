import Foundation
import SwiftUI
import GEOSwift

struct GeometryCollectionView: View {
    var identifiableGeometryCollection: IdentifiableGeometryCollection
    var gridGeometry: GeometryProxy
    
    var body: some View {
        ZStack {
            ForEach(identifiableGeometryCollection.geometries, id: \.id) { geometry in
                GeometryView(selectableIdentifiableGeometry: SelectableIdentifiableGeometry(geometry), gridGeometry: gridGeometry)
            }
        }
    }
}
