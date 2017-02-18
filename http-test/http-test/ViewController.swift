//
//  ViewController.swift
//  http-test
//
//  Created by Sachin Leelasena on 18/02/2017.
//  Copyright © 2017 Sachin Leelasena. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Clear web cache
        URLCache.shared.removeAllCachedResponses()
        URLCache.shared.diskCapacity = 0
        URLCache.shared.memoryCapacity = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var posture_label: UILabel!
    
    @IBAction func upload_btn(_ sender: UIButton) {
        
        // HTTP POST to server
        let parameters: Parameters = [
            "foo": "bar",
            "baz": 1,
            "qux": [
                "x": 1,
                "y": 2,
                "z": 3
            ]
        ]
        
//        Alamofire.request("https://posttestserver.com/post.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in debugPrint(response)
//            
//        }
        
//        Alamofire.request("https://284a4940.ngrok.io/post1", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in debugPrint(response)
//            
//        }
        
        Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters).responseJSON{response in debugPrint(response)
        }
    }
    
    
    @IBAction func btn(_ sender: UIButton){
        
        // HTTP GET from server
//        Alamofire.request("https://httpbin.org/ip").responseJSON { response in
//            debugPrint(response)
//            
//            if let json = response.result.value {
//                print("JSON: \(json)")
//                let x = json as? [String: Any]
//                print(x?["origin"] as! String)
//                self.posture_label.text = x?["origin"] as? String
//                self.posture_label.sizeToFit()
//            }
//        }
        
        Alamofire.request("https://284a4940.ngrok.io/result1.json").responseJSON { response in
            debugPrint(response)
            
            if let json = response.result.value {
                print("JSON: \(json)")
                let x = json as? [String: Any]
                print(x?["posture"] as! String)
                self.posture_label.text = x?["posture"] as? String
                self.posture_label.sizeToFit()
            }
        }
    }
}

