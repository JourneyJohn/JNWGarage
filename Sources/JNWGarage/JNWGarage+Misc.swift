//
//  File.swift
//  
//
//  Created by John on 2021/5/14.
//

#if os(iOS) || os(tvOS) //os(macOS)
import UIKit
#else
import AppKit
#endif

@available(iOS 12.0, *)
func getCurrentAppearance() -> UIUserInterfaceStyle {
    if #available(iOS 13.0, *) {
        return UITraitCollection.current.userInterfaceStyle
    } else {
        return .unspecified
    }
}
