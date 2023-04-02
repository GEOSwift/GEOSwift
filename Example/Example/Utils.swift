import Foundation
import SwiftUI

func colorForUUID(_ uuid: UUID) -> Color {
    let string = uuid.uuidString
    let startIndex = string.index(string.startIndex, offsetBy: 9)
    let endIndex = string.index(string.startIndex, offsetBy: 12)
    let subString = string[startIndex...endIndex]
    let hexValue = Int(subString, radix: 16) ?? 0
    let red = Double((hexValue >> 8) & 0xFF) / 255.0
    let green = Double((hexValue >> 4) & 0xFF) / 255.0
    let blue = Double(hexValue & 0xFF) / 255.0
    return Color(red: red, green: green, blue: blue)
}
