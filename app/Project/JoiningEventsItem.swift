//
//  JoiningEventsItem.swift
//  Project
//
//  Created by Alexander Rinne on 14-06-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//


import Foundation
import Firebase
import FirebaseDatabase

struct JoiningEventsItem {
    
//    constant
    let placeID: String
    
//    create instance
    init(placeID: String) {
        
        self.placeID = placeID
        
    }
    
//    make object of firebase data
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        placeID = snapshotValue["placeID"] as! String
    }
    
    
//    convert data to type any
    func toAnyObject() -> Any {
        return [
            "placeID": placeID,
        ]
    }
    
}
