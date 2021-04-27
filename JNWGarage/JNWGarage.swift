//
//  JNWGarage.swift
//  JNWGarage
//
//  Created by John on 2021/4/2.
//

import UIKit

public struct JNWAdaptorWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public struct JNWAdaptorTypeWrapper<Base> {
    public let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol JNWAdaptor { }
public protocol JNWTypeAdaptor { }

extension JNWAdaptor {
    public var jnw: JNWAdaptorWrapper<Self> {
        get { return JNWAdaptorWrapper(self) }
        set { }
    }
}

extension JNWTypeAdaptor {
    public static var jnw: JNWAdaptorTypeWrapper<Self.Type> {
        get { return JNWAdaptorTypeWrapper(self) }
        set { }
    }
}

//extension JNWAdaptorWrapper where Base: UIColor {
//    
//}


// MARK: color
//extension UIColor: JNWAdaptor { }
//extension UIColor: JNWTypeAdaptor { }
