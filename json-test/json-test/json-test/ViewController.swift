//
//  ViewController.swift
//  json-test
//
//  Created by Adi Krpo on 15/02/2017.
//  Copyright © 2017 Adi Krpo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // prepare json data
        let json: [String: Any] = ["accelX": "-1",
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
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "https://posttestserver.com/post.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print(responseJSON)
            }

        }
        task.resume()
        
        // Read JSON from HTTP server
        
        let read_url = URL(string: "https://httpbin.org/get?show_env=1")
//        let read_url = URL(string: "https://putsreq.com/3460J109NNrmz6ma3Zox")
        
        let task2 = URLSession.shared.dataTask(with: read_url!) { data, response, error in
            guard error == nil else {
                print(error as Any)
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            print("Printing JSON as dictionary:")
            let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            if let j = json{
                print(j)
            }
            
        }
        
        
        task2.resume()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
