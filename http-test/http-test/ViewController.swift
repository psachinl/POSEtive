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
    
    let route = "/people/" // Route to db
    let id = "b173a74c-2708-4e73-987d-5357371c5162" // ID of user in db

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
//        let parameters: Parameters = [
//            "firstName": "bar",
//            "lastName": "foor",
//            "qux": [
//                "x": 1,
//                "y": 2,
//                "z": 3
//            ]
//        ]
        
        let parameters: Parameters = ["accelX": ["-1", "-0.9"],
                                      "accelY": "0",
                                      "accelZ": "0",
                                      "gyroX" : "0.5",
                                      "gyroY" : "-2.7",
                                      "gyroZ" : "-3.2",
                                      "magX"  : "-22.5",
                                      "magY"  : "-21.9",
                                      "magZ"  : "38.2",
                                      "units" :[
                                        "accel" : "g",
                                        "gyro"  : "deg/s",
                                        "mag"   : "uT"
                                        ]
                                    ]
        
        Alamofire.request("https://posttestserver.com/post.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in debugPrint(response)
            
        }
        
//        Alamofire.request("http://ec2-52-56-146-49.eu-west-2.compute.amazonaws.com/data.php", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in debugPrint(response)
//            // Check http://localhost:4040/inspect/http to see if POST request works but is blocked (405 error)
//        }
        
//        Alamofire.request("https://httpbin.org/post", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON{response in debugPrint(response)
//        }
    }
    
    
    @IBAction func btn(_ sender: UIButton){
        
        // ngrok URL needs to be changed each time ngrok is restarted
        let get_path = "https://eda14b7e.ngrok.io" + route + id
        
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
        
        // AWS HTTP GET
//        Alamofire.request("http://ec2-52-56-146-49.eu-west-2.compute.amazonaws.com/result1.json").responseJSON { response in
//            debugPrint(response)
//            
//            if let json = response.result.value {
//                print("JSON: \(json)")
//                let x = json as? [String: Any]
//                print(x?["posture"] as! String)
//                self.posture_label.text = x?["posture"] as? String
//                self.posture_label.sizeToFit()
//            }
//        }
        
//        // Read posture result from server
//        Alamofire.request(get_path).responseJSON { response in debugPrint(response)
//            
//            if let json = response.result.value {
//                print("JSON: \(json)")
//                // Convert JSON to dictionary
//                let pos_dict = json as? [String: Any]
//                print(pos_dict?["posture"] as! String)
//                self.posture_label.text = pos_dict?["posture"] as? String
//                self.posture_label.sizeToFit()
//            }
//        }
        
        // Read posture result from server
        Alamofire.request(get_path).responseJSON { response in debugPrint(response)
            
            if let json = response.result.value {
                // Convert JSON to dictionary and store posture result (classification)
                let pos_dict = json as? [String: Any]
                let pos_clas = pos_dict?["posture"] as? String
                
                if pos_clas == "Bad"{
                    // Trigger intervention to correct posture
                }
            }
        }
    }
    
    @IBAction func trigger_notif(_ sender: UIButton) {
        let nc = NotificationCenter.default
        nc.post(name:Notification.Name(rawValue:"MyNotification"),
                object: nil,
                userInfo: ["message":"Hello there!", "date":Date()])
    }
    
    
}

