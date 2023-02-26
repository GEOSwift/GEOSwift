import SwiftUI

struct DoubleGeometryOperationView: View {
    var geometryModel: GeometryModel
    @Binding var showSheet: Bool
    
    var body: some View {
        Group {
            Button("intersection", action: {
                geometryModel.intersection(input: geometryModel.selectedGeometries[0].geometry, secondGeometry: geometryModel.selectedGeometries[1].geometry)
                showSheet = false
            })
            Button("difference", action: {
                geometryModel.difference(input: geometryModel.selectedGeometries[0].geometry, secondGeometry: geometryModel.selectedGeometries[1].geometry)
                showSheet = false
            })
            Button("union", action: {
                geometryModel.union(input: geometryModel.selectedGeometries[0].geometry, secondGeometry: geometryModel.selectedGeometries[1].geometry)
                showSheet = false
            })
            Button("clear selected", action: {
                geometryModel.clear()
                showSheet = false
            })
        }
    }
}
