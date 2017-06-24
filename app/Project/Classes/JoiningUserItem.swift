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
    
    let facebookID: String

    init(facebookID: String) {

        self.facebookID = facebookID

    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        facebookID = snapshotValue["facebookID"] as! String
    }

    func toAnyObject() -> Any {
        return [
            "facebookID": facebookID,
        ]
    }
    
}
