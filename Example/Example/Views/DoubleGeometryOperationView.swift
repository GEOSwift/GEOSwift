import SwiftUI

struct DoubleGeometryOperationView: View {
    var geometryModel: GeometryModel
    @Binding var showSheet: Bool
    
    var body: some View {
        Group {
            Button("intersection", action: {
                showSheet = false
                geometryModel.intersection(firstGeometry: geometryModel.selectedGeometries[0].identifiableGeometry.geometry, secondGeometry: geometryModel.selectedGeometries[1].identifiableGeometry.geometry)
            })
            Button("difference", action: {
                showSheet = false
                geometryModel.difference(firstGeometry: geometryModel.selectedGeometries[0].identifiableGeometry.geometry, secondGeometry: geometryModel.selectedGeometries[1].identifiableGeometry.geometry)
            })
            Button("union", action: {
                showSheet = false
                geometryModel.union(firstGeometry: geometryModel.selectedGeometries[0].identifiableGeometry.geometry, secondGeometry: geometryModel.selectedGeometries[1].identifiableGeometry.geometry)
            })
            Button("clear selected", action: {
                showSheet = false
                geometryModel.clear()
            })
        }
    }
}
