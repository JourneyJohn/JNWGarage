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
        
        JNWNetwork.shared.request(with: <#T##URL#>, method: <#T##JNWNetwork.RequestMethod#>, successHandler: <#T##((Data?) -> ())?##((Data?) -> ())?##(Data?) -> ()#>, failureHandler: <#T##((Error) -> ())?##((Error) -> ())?##(Error) -> ()#>)
    }


}

