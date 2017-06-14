//
//  UserItem.swift
//  Project
//
//  Created by Alexander Rinne on 14-06-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct UserItem {
    
    let facebookID: String
    let credential: String
    let name: String
    let profilePictureURL: String
    
    init(facebookID: String, credential: String, name: String, profilePictureURL: String) {
        self.facebookID = facebookID
        self.credential = credential
        self.name = name
        self.profilePictureURL = profilePictureURL
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        facebookID = snapshotValue["facebookID"] as! String
        credential = snapshotValue["credential"] as! String
        name = snapshotValue["name"] as! String
        profilePictureURL = ["profilePictureURL"] as! String
        
        
    }
    
    func toAnyObject() -> Any {
        return [
            "facebookID": facebookID,
            "credential": credential,
            "name": name,
            "profilePictureURL": profilePictureURL
        ]
    }
    
}
