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


class Facebook {
    
//    func authenticateUser() -> String? {
//        
//        if (FBSDKAccessToken.current() != nil) {
//            let params = ["fields" : "id, name"]
//            let graphRequest = GraphRequest(graphPath: "me", parameters: params)
//            graphRequest.start {
//                (urlResponse, requestResult) in
//                
//                switch requestResult {
//                case .failed(let error):
//                    print("error in graph request:", error)
//                    return
//                case .success(let graphResponse):
//                    if let responseDictionary = graphResponse.dictionaryValue {
//                        print(responseDictionary)
//                        let facebookID = (responseDictionary["id"]!) as! String
//                        print("check10:facebookID")
//
//                        return facebookID
//                        
//                    }
//                }
//            }
//        }
//
//        
//    }
//    static let sharedInstance = Facebook()
//    
//    func facebookRequest(facebookID: String) -> Dictionary<Key: Hashable, Any> {
//        let params = ["fields" : "email, name"]
//        let graphRequest = GraphRequest(graphPath: "me", parameters: params)
//        graphRequest.start {
//            (urlResponse, requestResult) in
//            
//            switch requestResult {
//            case .failed(let error):
//                print("error in graph request:", error)
//                break
//            case .success(let graphResponse):
//                if let responseDictionary = graphResponse.dictionaryValue {
//                    print(responseDictionary)
//                    
//                    print(responseDictionary["name"])
//                    print(responseDictionary["email"])
//                    return responseDictionary
//
//                }
//            }
//        }
//    }

}


//import Foundation
//import FacebookCore
//
//struct MyProfileRequest: GraphRequestProtocol {
//    struct Response: GraphResponseProtocol {
//        init(rawResponse: Any?) {
//            // Decode JSON from rawResponse into other properties here.
//        }
//    }
//    
//    var graphPath = "/me"
//    var parameters: [String : Any]? = ["fields": "id, name"]
//    var accessToken = AccessToken.current
//    var httpMethod: GraphRequestHTTPMethod = .GET
//    var apiVersion: GraphAPIVersion = .defaultVersion
//
//
//
//    let connection = GraphRequestConnection()
//    connection.add(MyProfileRequest()) { response, result in
//        switch result {
//        case .success(let response):
//            print("Custom Graph Request Succeeded: \(response)")
//            print("My facebook id is \(response.dictionaryValue?["id"])")
//            print("My name is \(response.dictionaryValue?["name"])")
//        case .failed(let error):
//            print("Custom Graph Request Failed: \(error)")
//        }
//    connection.start()
//}
//}
