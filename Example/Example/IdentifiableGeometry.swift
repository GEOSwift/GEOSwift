import Foundation
import GEOSwift

struct IdentifiableGeometry: Identifiable {
    let id = UUID()
    let geometry: Geometry
    var selected = false
}
