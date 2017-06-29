//
//  JoiningUserItem.swift
//  Project
//
//  Created by Alexander Rinne on 14-06-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct JoiningUserItem {
    
//    constant
    let facebookID: String
    
//    create instance
    init(facebookID: String) {
        
        self.facebookID = facebookID
        
    }
    
//    make object of firebase data
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        facebookID = snapshotValue["facebookID"] as! String
    }
    
//    convert data to type any
    func toAnyObject() -> Any {
        return [
            "facebookID": facebookID,
        ]
    }
    
}
