//
// This file (and all other Swift source files in the Sources directory of this playground)
// will be precompiled into a framework which is automatically made available to GEOSwiftPlayground.playground.
//

import Foundation

extension NSData {
    public class func fromHexString (string: String) -> NSData {
        // Based on: http://stackoverflow.com/a/2505561/313633
        let data = NSMutableData()
        var temp = ""
        for char in string {
            temp += String(char)
            if temp.count == 2 {
                let scanner = Scanner(string: temp)
                var value: CUnsignedInt = 0
                scanner.scanHexInt32(&value)
                data.append(&value, length: 1)
                temp = ""
            }
        }
        return data
    }
}

// swiftlint:disable:next line_length
let geometryWKBHexString = "010300000002000000050000000000000000804140000000000000244000000000008046400000000000C046400000000000002E40000000000000444000000000000024400000000000003440000000000080414000000000000024400400000000000000000034400000000000003E40000000000080414000000000008041400000000000003E40000000000000344000000000000034400000000000003E40"
public func geometryWKB() -> NSData { return NSData.fromHexString(string: geometryWKBHexString) }
