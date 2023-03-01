import SwiftUI
import GEOSwift

struct SampleGeometryOperationView: View {
    var geometryModel: GeometryModel
    @Binding var showSheet: Bool
    @Binding var isImporting: Bool
    
    var body: some View {
        Group {
            Button("import", action: {
                isImporting = true
            })
            .fileImporter(isPresented: $isImporting,
                          allowedContentTypes: [.json]) { result in
                geometryModel.importGeometry(result)
                isImporting = false
                showSheet = false
            }
            Button("point", action: {
                geometryModel.geometries.append(IdentifiableGeometry(geometry: .point(Point(x: 3, y: 4))))
                showSheet = false
            })
            Button("multiPoint", action: {
                geometryModel.geometries.append(IdentifiableGeometry(geometry: .multiPoint(MultiPoint(
                    points: [
                        Point(x: 135, y: 509),
                        Point(x: 290, y: 132),
                        Point(x: 359, y: 689)]))))
                showSheet = false
            })
            Button("polygon", action: {
                geometryModel.geometries.append(IdentifiableGeometry(geometry: .polygon(try! Polygon(exterior: Polygon.LinearRing(points: [
                    Point(x: 5, y: 9),
                    Point(x: 390, y: 632),
                    Point(x: 159, y: 409),
                    Point(x: 5, y: 9)])
                ))))
                showSheet = false
            })
            Button("multiPolygon", action: {
                geometryModel.geometries.append(IdentifiableGeometry(geometry: .multiPolygon(MultiPolygon(polygons:
                    [try! Polygon(exterior: Polygon.LinearRing(points: [
                        Point(x: 305, y: 9),
                        Point(x: 250, y: 532),
                        Point(x: 5, y: 389),
                        Point(x: 305, y: 9)])
                    ),
                     try! Polygon(exterior: Polygon.LinearRing(points: [
                        Point(x: 5, y: 709),
                        Point(x: 300, y: 2),
                        Point(x: 49, y: 89),
                        Point(x: 5, y: 709)])
                     )]))))
                showSheet = false
            })
            Button("lineString", action: {
                geometryModel.geometries.append(IdentifiableGeometry(geometry: .lineString(try! LineString(points: [
                    Point(x: 105, y: 9),
                    Point(x: 90, y: 532),
                    Point(x: 259, y: 389),
                    Point(x: 105, y: 9)]))))
                showSheet = false
            })
            Button("multiLineString", action: {
                geometryModel.geometries.append(IdentifiableGeometry(geometry: .multiLineString(MultiLineString(lineStrings:
                    [try! LineString(points: [
                        Point(x: 5, y: 9),
                        Point(x: 390, y: 312),
                        Point(x: 59, y: 489),
                        Point(x: 5, y: 9)]),
                     try! LineString(points: [
                        Point(x: 25, y: 29),
                        Point(x: 120, y: 22),
                        Point(x: 229, y: 489),
                        Point(x: 25, y: 29)])
                    ]))))
                showSheet = false
            })
        }
    }
}
