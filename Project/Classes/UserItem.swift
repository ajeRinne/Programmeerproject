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
    let password: String
    let name: String
    let profilePictureURL: String
    
    init(facebookID: String, password: String, credential: String, name: String, profilePictureURL: String) {
        self.facebookID = facebookID
        self.password = password
        self.name = name
        self.profilePictureURL = profilePictureURL
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        facebookID = snapshotValue["facebookID"] as! String
        password = snapshotValue["password"] as! String
        name = snapshotValue["name"] as! String
        profilePictureURL = ["profilePictureURL"] as! String
        
        
    }
    
    func toAnyObject() -> Any {
        return [
            "facebookID": facebookID,
            "password": password,
            "name": name,
            "profilePictureURL": profilePictureURL
        ]
    }
    
}
