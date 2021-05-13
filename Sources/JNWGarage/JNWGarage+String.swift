//
//  JNWGarage+String.swift
//  JNWGarage
//
//  Created by John on 2021/4/26.
//

import UIKit

extension String: JNWAdaptor { }

extension JNWAdaptorWrapper where Base == String {
    
    func fromHex() -> UInt64? {
        
        var result: UInt64 = 0
        
        var hexStr = self.base
        if hexStr.hasPrefix("0x") {
            hexStr.removeFirst(2)
        }
        
        for (index, item) in hexStr.reversed().enumerated() {
            var resInt: UInt64 = 0
            let scanner = Scanner(string: String(item))
            if (scanner.scanHexInt64(&resInt)) {
                result += resInt * UInt64(pow(CGFloat(16), CGFloat(index)))
            } else {
                return nil
            }
        }
        
        return result
    }
}
