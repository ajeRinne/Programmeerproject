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
    
    let placeID: String
    
    init(placeID: String) {
        
        self.placeID = placeID
        
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        placeID = snapshotValue["placeID"] as! String
    }
    
    func toAnyObject() -> Any {
        return [
            "placeID": placeID,
        ]
    }
    
}
