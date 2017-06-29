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
    
//    constants
    let placeID: String
    let facebookID: String
    let placeName: String
    let eventName: String
    let placeTime: String
    let placeDescription: String
    
//    create intance
    init(placeID: String, facebookID: String, placeName: String, eventName: String, placeTime: String, placeDescription: String) {
        
        self.placeID = placeID
        self.facebookID = facebookID
        self.placeName = placeName
        self.eventName = eventName
        self.placeTime = placeTime
        self.placeDescription = placeDescription
    }
    
//    make object of firebase data
    init(snapshot: DataSnapshot) {
        
        let snapshotValue = snapshot.value as! [String: AnyObject]
        placeID = snapshotValue["placeID"] as! String
        facebookID = snapshotValue["facebookID"] as! String
        placeName = snapshotValue["placeName"] as! String
        eventName = snapshotValue["eventName"] as! String
        placeTime = snapshotValue["placeTime"] as! String
        placeDescription = snapshotValue["placeDescription"] as! String
    }
    
//    convert data to type any
    func toAnyObject() -> Any {
        
        return [
            "placeID": placeID,
            "facebookID": facebookID,
            "placeName": placeName,
            "eventName": eventName,
            "placeTime": placeTime,
            "placeDescription": placeDescription,
        ]
    }
    
}
