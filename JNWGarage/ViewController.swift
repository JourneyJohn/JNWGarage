//
//  ViewController.swift
//  JNWGarage
//
//  Created by John on 2021/4/2.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        JNWNetwork.shared.request(with: "https://www.baidu.com", method: .GET) { (data, response) in
            
        } failureHandler: { (error) in
            
        }

        
    }


}

