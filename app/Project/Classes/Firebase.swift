//
//  Firebase.swift
//  
//
//  Created by Alexander Rinne on 28-06-17.
//
//

import Foundation
import Firebase

class Firebase{
    
    static let sharedInstance = Firebase()
//    static let sharedInstance = Firebase()
    
    let placeTableRef = Database.database().reference(withPath: "placesTable")
    let userTableRef = Database.database().reference(withPath: "usersTable")
    
//    func loadUserItem(userID: String){
//        let userItemRef = userTableRef.child(userID)
//        userItemRef.observe.ste
//    }
    
    func loadJoiningEventsTable(facebookID: String, joiningEventsItem: [JoiningEventsItem], addedByMeItems: [PlaceItem]) {
        
        let userItemRef = userTableRef.child(facebookID)
        let joiningEventsRef = userItemRef.child("joinsEvents")
        joiningEventsRef.queryOrdered(byChild: "joinsEvents").observe(.value, with: { snapshot in
            
            var joiningEventsItemsNew: [JoiningEventsItem] = []
            for item in snapshot.children {
                
                let joiningEventsItem = JoiningEventsItem(snapshot: item as! DataSnapshot)
                joiningEventsItemsNew.append(joiningEventsItem)
            }
            
        })

    }
    
}
