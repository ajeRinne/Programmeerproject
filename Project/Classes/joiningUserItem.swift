//
//  joiningUserItem.swift
//  Project
//
//  Created by Alexander Rinne on 14-06-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

//
//  PlaceItem.swift
//  Project
//
//  Created by Alexander Rinne on 14-06-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct JoiningUserItem {
    
    let placeID: String
    let facebookID: String
    let credential: String
    let name: String
    let profilePictureURL: String
    
    
    init(placeID: String, credential: String, placeName: String, placePictureURL: String, placeTime: String, placeDescription: String) {
        self.placeID = placeID
        self.facebookID = facebookID
        self.credential = credential
        self.name = name
        self.profilePictureURL = profilePictureURL
        
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        placeID = snapshotValue["placeID"] as! String
        facebookID = snapshotValue["facebookID"] as! String
        credential = snapshotValue["credential"] as! String
        name = snapshotValue["name"] as! String
        profilePictureURL = ["profilePictureURL"] as! String
        
        
    }
    
    func toAnyObject() -> Any {
        return [
            "placeID": placeID,
            "facebookID": facebookID,
            "credential": credential,
            "name": name,
            "placePictureURL": placePictureURL
        ]
    }
    
}
