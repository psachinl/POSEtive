//
//  PosturePercentages.swift
//  realm-charts
//
//  Created by Sachin Leelasena on 21/02/2017.
//  Copyright © 2017 Sachin Leelasena. All rights reserved.
//

import Foundation
import RealmSwift

class PosturePercentages: Object { // superclass is Realm Object
    dynamic var date: Date = Date()
    dynamic var count: Int = Int(0)
    dynamic var classification: String = String("")
    
    // Save to Realm db
    func save() {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(self)
            }
        } catch let error as NSError {
            fatalError(error.localizedDescription)
        }
    }
    
}
