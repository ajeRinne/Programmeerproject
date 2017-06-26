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
    /**
     Sent to the delegate when the button was used to logout.
     - Parameter loginButton: The varton that was clicked.
     */
    var facebookID : String = ""
    var usersRef : DatabaseReference!
    var password: String = "pass"
    var name : String = ""
    var profilePictureURL : String = ""


    @IBOutlet var logInWithFacebookButton: Button!
    @IBOutlet var userNameTextField: Textfield!
    @IBOutlet var passwordTextField: Textfield!
    
    @IBAction func logInWithFacebookButtonTouched(_ sender: Any) {
        print("check11")
        self.performSegue(withIdentifier: "loginToMyPlaces", sender: nil)
        
    }
    

    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
    
                if let error = error {
            print(error.localizedDescription)
            return
                    
        } else {
            print("user logged in")
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
                        print(responseDictionary)
                        print("check12")
                        self.name = (responseDictionary["name"]!) as! String
                        self.facebookID = (responseDictionary["id"]!) as! String
                        print("check13")
                        print(self.facebookID)
                        self.performSegue(withIdentifier: "loginToMyPlaces", sender: nil)
                        
                    }
                }
            }
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
                        print("check14")
                        self.profilePictureURL = dict["url"]! as! String
                        
                    }
                }
                
            }

            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            print("check15")
            print(credential)
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    print("could not authenticate user error: \(error)")
                    return
                }
                // User is signed in
                print("user authenticated in to firebase")
                print(self.facebookID, type(of: self.facebookID), self.password, type(of: self.password), self.name, type(of: self.name), self.profilePictureURL, type(of: self.profilePictureURL))
               let userItem = UserItem(facebookID: self.facebookID, password: self.password, name: self.name, profilePictureURL: self.profilePictureURL)
//                let userCredential = credential as! String
                let userItemRef = self.usersRef.child(self.facebookID)
                userItemRef.setValue(userItem.toAnyObject())
                self.performSegue(withIdentifier: "loginToMyPlaces", sender: nil)
                
            }
        }

        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "loginToMyPlaces") {
            let navigationController = segue.destination as! UINavigationController
            let viewController = navigationController.topViewController as! MyPlacesViewController
//            let viewController = segue.destination as! MyPlacesViewController
            viewController.facebookID = facebookID
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        usersRef = Database.database().reference(withPath: "usersTable")
//        let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
//        print("check13: \(credential)")
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loginButton)
        
        
        
        let horizontalConstraint = NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: passwordTextField, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: passwordTextField, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 90)
        let widthConstraint = NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 185)
        let heightConstraint = NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 25)
        
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])

        
        if FBSDKAccessToken.current() != nil {
            print("user: \(FBSDKAccessToken.current()!) signed in")
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
                        print(responseDictionary)
                        print("check16")
                        self.name = (responseDictionary["name"]!) as! String
                        self.facebookID = (responseDictionary["id"]!) as! String
                        print("check17")
                        print(self.facebookID)
                        self.performSegue(withIdentifier: "loginToMyPlaces", sender: nil)
                    }
                }
            }
        }

        
    }

    
    override func viewDidAppear(_ animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

