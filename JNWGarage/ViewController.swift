//
//  ViewController.swift
//  JNWGarage
//
//  Created by John on 2021/4/2.
//

import UIKit

struct ExampleModel: Codable {
    var name: String?
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        JNWNetwork.shared.request(with: "https://www.baidu.com", method: .GET) { (data, response) in
            
        } failureHandler: { (error) in
            
        }

        
//        let q = DispatchQueue(label: "com.john.example.queue", qos: .background, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        let q = OperationQueue()
        q.name = "com.john.example.queue"
        
        JNWNetwork
        .shared
        .callbackInQueue(queue: q)
        .request(with: "https://www.baidu.com", method: .GET, params: [:]) { (model: ExampleModel?) in
            print("current queue: \(Thread.current)")
        } failureHandler: { (error) in
            print("current queue: \(Thread.current)")
//            dispatch_get_global_queue(qos_class_self(), 0)
        }
        
        
        JNWNetwork
        .shared
            .callbackInQueue(queue: .main)
        .request(with: "https://www.baidu.com", method: .GET, params: [:]) { (model: ExampleModel?) in
            print("current queue: \(Thread.current)")
        } failureHandler: { (error) in
            print("current queue: \(Thread.current)")
//            dispatch_get_global_queue(qos_class_self(), 0)
        }

        
        view.backgroundColor = UIColor.jnw.hex(str: "0x73ab9f")
        
    }


}

