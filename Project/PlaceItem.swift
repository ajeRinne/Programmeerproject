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

struct PlaceItem {
    
    let placeID: String
    let credential: String
    let placeName: String
    let placePictureURL: String
    let placeTime: String
    let placeDescription: String


    init(placeID: String, credential: String, placeName: String, placePictureURL: String, placeTime: String, placeDescription: String) {
        self.placeID = placeID
        self.credential = credential
        self.placeName = placeName
        self.placePictureURL = placePictureURL
        self.placeTime = placeTime
        self.placeDescription = placeDescription
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        placeID = snapshotValue["placeID"] as! String
        credential = snapshotValue["credential"] as! String
        placeName = snapshotValue["placeName"] as! String
        profilePictureURL = ["profilePictureURL"] as! String
        placeTime = snapshotValue["placeTime"] as! String
        placeDescription = snapshotValue["placeDescription"] as! String
        
    }
    
    func toAnyObject() -> Any {
        return [
            "placeID": placeID,
            "credential": credential,
            "placeName": placeName,
            "placePictureURL": placePictureURL,
            "placeTime" : placeTime,
            "placeDescriptoin" : placeDescription
        ]
    }
    
}
