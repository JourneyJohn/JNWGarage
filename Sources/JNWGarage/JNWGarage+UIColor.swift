//
//  JNWGarage+UIColor.swift
//  JNWGarage
//
//  Created by John on 2021/4/27.
//

import UIKit

extension UIColor : JNWTypeAdaptor { }

extension JNWAdaptorTypeWrapper where Base == UIColor.Type {
    
    public func hex(str: String) -> UIColor {
        
        var colorStr = str
        if colorStr.hasPrefix("0x") {
            colorStr.removeFirst(2)
        } else if colorStr.hasPrefix("#") {
            colorStr.removeFirst()
        }
        
        var alpha: CGFloat = 1
        if colorStr.count == 8 {
            let index = colorStr.index(colorStr.startIndex, offsetBy: 1)
            let alphaStr = String(colorStr[colorStr.startIndex...index])
            alpha = CGFloat(alphaStr.jnw.fromHex() ?? 1)/CGFloat(255)
            colorStr.removeFirst(2)
        }
        if colorStr.count != 6 {
            return .clear
        }
        colorStr = colorStr.uppercased()
        
        let validColorCharater = { (char: String.Element) -> Bool in
            return ("0"..."9").contains(String(char)) || ("A"..."F").contains(String(char))
        }
        
        for char in colorStr {
            if !validColorCharater(char) {
                return .clear
            }
        }
        
        let rEndIndex = colorStr.index(colorStr.startIndex, offsetBy: 1)
        let gEndIndex = colorStr.index(rEndIndex, offsetBy: 1)
        let bEndIndex = colorStr.index(gEndIndex, offsetBy: 1)
        
        let r = String(colorStr[colorStr.startIndex...rEndIndex]).jnw.fromHex() ?? 0
        let g = String(colorStr[rEndIndex...gEndIndex]).jnw.fromHex() ?? 0
        let b = String(colorStr[gEndIndex...bEndIndex]).jnw.fromHex() ?? 0
        
        return UIColor(red: CGFloat(Double(r)/255.0), green: CGFloat(Double(g)/255.0), blue: CGFloat(Double(b)/255.0), alpha: alpha)
    }
}
