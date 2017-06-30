//
//  LoginViewController.swift
//  Project
//
//  Created by Alexander Rinne on 06-06-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FBSDKLoginKit
import FacebookCore

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

//    MARK: - Variables
    var facebookID : String = ""
    var userTableRef : DatabaseReference!
    var password: String = "pass"
    var name : String = ""
    var profilePictureURL : String = ""
    
//    MARK: - Outlets
    @IBOutlet var meetAppLabel: UILabel!
    @IBOutlet var logInWithFacebookButton: Button!
    @IBOutlet var userNameTextField: Textfield!
    @IBOutlet var passwordTextField: Textfield!
    
//    MARK: - Actions
    @IBAction func logInWithFacebookButtonTouched(_ sender: Any) {
        print("check11")
        self.performSegue(withIdentifier: "loginToMyPlaces", sender: nil)
    }
    
    
    // MARK: - viewController
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        constants
        let loginButton = FBSDKLoginButton()
        
//        setup loginButton
        loginButton.delegate = self
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginButton)
        
//        declare database
        userTableRef = Database.database().reference(withPath: "usersTable")
        
//        add listeners
        NotificationCenter.default.addObserver(self, selector: #selector(facebookLoaded), name: NSNotification.Name("facebookIDLoaded"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(myPlacesSegue), name: NSNotification.Name("userInstanceCreated"), object: nil)
        
//        set constraints for loginButton
        let horizontalConstraint = NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: meetAppLabel, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: view, attribute: NSLayoutAttribute.bottomMargin, multiplier: 1, constant: -100)
        let widthConstraint = NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 185)
        let heightConstraint = NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 25)
        
//        add contraints to view
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
//        authenticate user
        if FBSDKAccessToken.current() != nil {

            Facebook.sharedInstance.facebookAuth(accessToken:  FBSDKAccessToken.current())
            self.facebookID = Facebook.sharedInstance.facebookID

        }
    }

    
// MARK: - Facebook login
    
//    log user in with FBSDKLoginButton
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
//            error handling
            if let error = error {
            print(error.localizedDescription)
            return
                    
        } else {
                
//                authenticate user
                if FBSDKAccessToken.current() != nil {
                Facebook.sharedInstance.facebookAuth(accessToken: FBSDKAccessToken.current())
                self.facebookID = Facebook.sharedInstance.facebookID
                print("user logged in")
            }
        }
    }
    
//    permitted logout option
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
    

//    check if user exists
    func facebookLoaded() {
        self.facebookID = Facebook.sharedInstance.facebookID
        
//        check if current facebookId matches one in database
        userTableRef.observeSingleEvent(of: .value, with: { (snapshot) in
            for item in snapshot.children {
                print("check113: \(self.facebookID)")
                print("check112: \(item)")
            }
            if snapshot.hasChild(self.facebookID){
                
                print("user exists")
                self.performSegue(withIdentifier: "loginToMyPlaces", sender: nil)
                
            } else {
                
                self.downloadUserInfo()
            }
        })
    }
    
//    download user details
    func downloadUserInfo() {
        
//        Facebook Graph API request
        let params = ["fields" : "id, name"]
        let graphRequest = GraphRequest(graphPath: "me", parameters: params)
            graphRequest.start {
            (urlResponse, requestResult) in
            
            switch requestResult {
                
            case .failed(let error):
                print("error in graph request:", error)
                break
                
            case .success(let graphResponse):
                
                if let responseDictionary = graphResponse.dictionaryValue {
                    
//                    save items from database locally
                    self.name = (responseDictionary["name"]!) as! String
                    self.facebookID = (responseDictionary["id"]!) as! String
                    
//                    initiate dowloadProfilePictureURL function
                    self.downloadProfilePictureURL()
                }
            }
        }
    }
    
//    download profile picture
    func downloadProfilePictureURL() {
        
//        Facebook Graph API request
        let pictureRequest = GraphRequest(graphPath: "me/picture?type=large&redirect=false", parameters: [:])
        pictureRequest.start{
            (urlResponse, requestResult) in
            
            switch requestResult {
            case .failed(let error):
                print("error in graph request:", error)
                break
            case .success(let graphResponse):
                if let responseDictionary = graphResponse.dictionaryValue {
                    print(responseDictionary)
                    
                    var dict: NSDictionary!
                    
                    dict = responseDictionary["data"] as! NSDictionary

                    
//                    cast profilePictureURL as String
                    self.profilePictureURL = dict["url"]! as! String
                    
//                    initiate createUserInstanceFunction
                    self.createUserInstance()
                }
            }
        }
    }
    
//    create instance to save variables
    func createUserInstance() {
        
//        save local variables in instance
            let userItem = UserItem(facebookID: self.facebookID, password: self.password, name: self.name, profilePictureURL: self.profilePictureURL)
        
//            upload instance to database
            let userItemRef = self.userTableRef.child(self.facebookID)
            userItemRef.setValue(userItem.toAnyObject())
        
//                notificate listener that data has been uploaded
            NotificationCenter.default.post(name: Notification.Name("UserInstanceCreated"), object: nil)
    }
    
    
// MARK: Segue
    
//    perform segue to MyPlacesViewController
    func myPlacesSegue(){
        self.performSegue(withIdentifier: "loginToMyPlaces", sender: nil)
        
    }
}

