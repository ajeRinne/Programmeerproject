//
//  PlaceItem.swift
//  
//
//  Created by Alexander Rinne on 15-06-17.
//
//

import Foundation
import Firebase
import FirebaseDatabase

struct PlaceItem {
    
    let placeID: String
    let facebookID: String
    let placeName: String
    let eventName: String
    let placePictureURL: String
    let placeTime: String
    let placeDescription: String
    let joiningUsers: String
    
    init(placeID: String, facebookID: String, placeName: String, eventName: String, placePictureURL: String, placeTime: String, placeDescription: String, joiningUsers: String) {
        
        self.placeID = placeID
        self.facebookID = facebookID
        self.placeName = placeName
        self.eventName = eventName
        self.placePictureURL = placePictureURL
        self.placeTime = placeTime
        self.placeDescription = placeDescription
        self.joiningUsers = joiningUsers
    }
    
    init(snapshot: DataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        placeID = snapshotValue["placeID"] as! String
        facebookID = snapshotValue["facebookID"] as! String
        placeName = snapshotValue["placeName"] as! String
        eventName = snapshotValue["eventName"] as! String
        placePictureURL = snapshotValue["placePictureURL"] as! String
        placeTime = snapshotValue["placeTime"] as! String
        placeDescription = snapshotValue["placeDescription"] as! String
        joiningUsers = snapshotValue["placeDescription"] as! String
    }
    
    func toAnyObject() -> Any {
        
        return [
            "placeID": placeID,
            "facebookID": facebookID,
            "placeName": placeName,
            "eventName": eventName,
            "placePictureURL": placePictureURL,
            "placeTime": placeTime,
            "placeTime": placeDescription,
            "joiningUsers": joiningUsers
        ]
    }
    
}
