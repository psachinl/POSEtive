//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
//
//let validDictionary = [
//    "numericalValue": 1,
//    "stringValue": "JSON",
//    "arrayValue": [0, 1, 2, 3, 4, 5]
//] as [String : Any]
//
//let invalidDictionary = [
//    "date": NSDate()
//]
//
//if JSONSerialization.isValidJSONObject(validDictionary) { // True
//    do {
//        let jsonData = try JSONSerialization.data(withJSONObject: validDictionary, options: .prettyPrinted)
//    } catch {
//        // Handle Error
//    }
//}
//
//if JSONSerialization.isValidJSONObject(invalidDictionary) { // False
//    // NSJSONSerialization.dataWithJSONObject(validDictionary, options: .PrettyPrinted) will produce an error if called
//}


// prepare json data
let json: [String: Any] = ["title": "Harambe",
                           "dict": ["1":"First", "2":"Second"]]

let jsonData = try? JSONSerialization.data(withJSONObject: json)

// create post request
let url = URL(string: "http://posttestserver.com/post.php")!
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