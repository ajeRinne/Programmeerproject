//
//  Facebook.swift
//  Project
//
//  Created by Alexander Rinne on 13-06-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import Foundation
import FacebookCore
import FBSDKLoginKit


class Facebook{
    
//    declare sharedInstance
    static let sharedInstance = Facebook()
    
//    variables
    var facebookID = String()
    
//    authenticates user
    func facebookAuth(accessToken: FBSDKAccessToken){
        
//        check if user is logged in
        if (accessToken != nil) {
            
//            graph request for user credentials
            let params = ["fields" : "id, name"]
            let graphRequest = GraphRequest(graphPath: "me", parameters: params)
                graphRequest.start {
                (urlResponse, requestResult) in
        
                    switch requestResult {
                        
                case .failed(let error):
                    
                    print("error in graph request:", error)
                        
                case .success(let graphResponse):
                    
                    if let responseDictionary = graphResponse.dictionaryValue {

//                        declare facebookID so it's accessible everywhere 
                        self.facebookID = (responseDictionary["id"]!) as! String

                        NotificationCenter.default.post(name: Notification.Name("facebookIDLoaded"), object: nil)
                    }
                }
            }
        }
    }
}
