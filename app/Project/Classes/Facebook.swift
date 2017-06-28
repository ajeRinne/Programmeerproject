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
    
    static let sharedInstance = Facebook()
    
    var facebookID = String()
    
    func facebookAuth(accessToken: FBSDKAccessToken){
        if (accessToken != nil) {
            let params = ["fields" : "id, name"]
            let graphRequest = GraphRequest(graphPath: "me", parameters: params)
                graphRequest.start {
                (urlResponse, requestResult) in
        
                    switch requestResult {
                case .failed(let error):
                    print("error in graph request:", error)
                case .success(let graphResponse):
                    if let responseDictionary = graphResponse.dictionaryValue {
                        print(responseDictionary)
                        self.facebookID = (responseDictionary["id"]!) as! String
                        print("check555:\(self.facebookID)")

                    }
                }
            }
        }
    }
}
