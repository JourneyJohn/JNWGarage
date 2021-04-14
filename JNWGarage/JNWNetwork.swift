//
//  JNWNetwork.swift
//  JNWGarage
//
//  Created by John on 2021/4/14.
//

import UIKit

class JNWNetwork {
    
    enum RequestMethod {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    let networkQueueStr = "com.john.jnwnetwork.queue"
    
    let networkQueue: DispatchQueue
    
    static let shared = JNWNetwork()
    
    init() {
        networkQueue = DispatchQueue(label: networkQueueStr,
                                     qos: .background,
                                     attributes: .concurrent,
                                     autoreleaseFrequency: .inherit,
                                     target: nil)
    }
    
    func request(url: URL,
                 method: RequestMethod,
                 header: [String:String]? = nil,
                 params: [String:String]? = nil,
                 body: [String:String]? = nil,
                 cachePolicy: NSURLRequest.CachePolicy = .reloadIgnoringCacheData,
                 timeoutInterval: TimeInterval = 60.0,
                 successHandler: (() -> ())? = nil,
                 failureHandler: ((Error) -> ())?) {
        
        let request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let httpResponse = response as? HTTPURLResponse
            let statusCode = httpResponse?.statusCode
            if let errorTmp = error {
                failureHandler?(errorTmp)
            } else {
                successHandler?()
            }
        }
        
        dataTask.resume()
    }
}
