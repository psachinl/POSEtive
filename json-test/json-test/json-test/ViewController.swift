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
        
        let str = "Hello, playground"
        //
        
        
        // prepare json data
        let json: [String: Any] = ["title": "Harambe",
                                   "dict": ["1":"First", "2":"Second"]]
        
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "https://posttestserver.com/post.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // insert json data to the request
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
        
        print(str)
        
        
        task.resume()
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //: Playground - noun: a place where people can play
    
}

