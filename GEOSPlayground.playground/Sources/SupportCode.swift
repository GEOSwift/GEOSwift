//
// This file (and all other Swift source files in the Sources directory of this playground) will be precompiled into a framework which is automatically made available to GEOSwiftPlayground.playground.
//

import Foundation

extension NSData {
    public class func fromHexString (string: String) -> NSData {
        // Based on: http://stackoverflow.com/a/2505561/313633
        var data = NSMutableData()
        
        var temp = ""
        
        for char in string {
            temp+=String(char)
            if(count(temp) == 2) {
                let scanner = NSScanner(string: temp)
                var value: CUnsignedInt = 0
                scanner.scanHexInt(&value)
                data.appendBytes(&value, length: 1)
                temp = ""
            }
        }
        return data as NSData
    }
}