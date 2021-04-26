//
//  JNWGarage+Data.swift
//  JNWGarage
//
//  Created by John on 2021/4/26.
//

import UIKit

extension Data : JNWAdaptor { }

extension JNWAdaptorWrapper where Base == Data {
    
    func tranferToJSONobject() -> [String: Any] {
        let jsonObject = try? JSONSerialization.jsonObject(with: self.base, options: .allowFragments)
        let dict = jsonObject as? [String: Any]
        return dict ?? [:]
    }
    
    func transferToModel<T: Decodable>(modelType: T.Type) -> T? {
        let decoder = JSONDecoder()
        let model = try? decoder.decode(modelType, from: self.base)
        return model
    }
}
