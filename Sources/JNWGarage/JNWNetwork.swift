//
//  JNWNetwork.swift
//  JNWGarage
//
//  Created by John on 2021/4/14.
//

import UIKit

class JNWNetwork {
    
    enum RequestMethod: String {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case DELETE = "DELETE"
    }
    
    typealias SuccessResponseHandler = ((Data?, URLResponse?) -> ())
    typealias FailureResponseHandler = ((Error?) -> ())
    
    let networkQueueStr = "com.john.jnwnetwork.queue"
    
    let networkQueue: DispatchQueue
    
    let networkOperationQueue: OperationQueue
    
    var callbackQueue: OperationQueue = .main
    
    static let shared = JNWNetwork()
    
    init() {
        networkQueue = DispatchQueue(label: networkQueueStr,
                                     qos: .background,
                                     attributes: .concurrent,
                                     autoreleaseFrequency: .inherit,
                                     target: nil)
        
        networkOperationQueue = OperationQueue()
        networkOperationQueue.maxConcurrentOperationCount = 1
        networkOperationQueue.name = networkQueueStr
        networkOperationQueue.qualityOfService = .background
    }
    
    public func callbackInQueue(queue: OperationQueue) -> Self {
        callbackQueue = queue
        return self
    }
    
    public func request<T: Decodable>(with url: String, method: JNWNetwork.RequestMethod, params: [String: Any]? = nil, successHandler: ((T?) -> ())?, failureHandler: FailureResponseHandler?) {
        
        let callbackQueue = self.callbackQueue
        
        request(with: url, method: method, params: params) { (data, response) in
            let model = data?.jnw.transferToModel(modelType: T.self)
            callbackQueue.addOperation {
                successHandler?(model)
            }
        } failureHandler: { (error) in
            callbackQueue.addOperation {
                failureHandler?(error)
            }
        }


    }
    
    public func request(with url: String, method: JNWNetwork.RequestMethod, params: [String: Any]? = nil, successHandler: SuccessResponseHandler?, failureHandler: FailureResponseHandler?) {
        var processedURL = url
        var body: Data? = nil
        switch method {
        case .POST:
            body = getData(from: params)
        case .GET:
            processedURL = makeupURL(with: url, params: params)
        default:
            print("not support")
        }
        
        guard let requestUrl = URL(string: processedURL) else { return }
        let callbackQueue = self.callbackQueue
        let op = JNWNetworkRequestOperation(url: requestUrl, method: method, body: body, callbackQueue: callbackQueue, successHandler: successHandler, failureHandler: failureHandler)
        networkOperationQueue.addOperation(op)
    }
    
    func makeupURL(with urlString: String, params: [String: Any]?) -> String {
        var resultUrl = urlString
        guard let paramsTmp = params else { return urlString }
        if resultUrl.contains("?") {
            for item in paramsTmp {
                resultUrl = "\(resultUrl)&\(item.key)=\(item.value)"
            }
        } else {
            for item in paramsTmp.enumerated() {
                if item.offset == 0 {
                    resultUrl = "\(resultUrl)?\(item.element.key)=\(item.element.value)"
                } else {
                    resultUrl = "\(resultUrl)&\(item.element.key)=\(item.element.value)"
                }
            }
        }
        return resultUrl
    }
    
    func getData(from dict: [String: Any]?) -> Data? {
        guard let dictTmp = dict else { return nil }
        let data = try? JSONSerialization.data(withJSONObject: dictTmp, options: .fragmentsAllowed)
        return data
    }
    
}

class JNWNetworkRequestOperation: Operation {
    
    let url: URL
    let method: JNWNetwork.RequestMethod
    let header: [String:String]?
    let params: [String:String]?
    let body: Data?
    let cachePolicy: NSURLRequest.CachePolicy
    let timeoutInterval: TimeInterval
    let successHandler: JNWNetwork.SuccessResponseHandler?
    let failureHandler: JNWNetwork.FailureResponseHandler?
    var dataTask: URLSessionDataTask?
    var callbackQueue: OperationQueue
    
    
    init(url: URL,
              method: JNWNetwork.RequestMethod,
              header: [String:String]? = nil,
              params: [String:String]? = nil,
              body: Data? = nil,
              cachePolicy: NSURLRequest.CachePolicy = .reloadIgnoringCacheData,
              timeoutInterval: TimeInterval = 60.0,
              callbackQueue: OperationQueue = .main,
              successHandler: JNWNetwork.SuccessResponseHandler? = nil,
              failureHandler: JNWNetwork.FailureResponseHandler? = nil) {
        
        self.url = url
        self.method = method
        self.header = header
        self.params = params
        self.body = body
        self.cachePolicy = cachePolicy
        self.timeoutInterval = timeoutInterval
        self.callbackQueue = callbackQueue
        self.successHandler = successHandler
        self.failureHandler = failureHandler
        
    }
    
    override func main() {
        dataTask?.cancel()
        dataTask = request()
        dataTask?.resume()
    }
    
    func request() -> URLSessionDataTask {
        
        var request = URLRequest(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        request.httpMethod = method.rawValue
        request.httpBody = body
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            guard let sself = self else { return }
//            let httpResponse = response as? HTTPURLResponse
//            let statusCode = httpResponse?.statusCode
            if let errorTmp = error {
                self.callbackQueue.addOperation {
                    self.failureHandler?(errorTmp)
                }
            } else {
                self.callbackQueue.addOperation {
                    self.successHandler?(data, response)
                }
            }
        }
        
        return dataTask
    }
}
