//
//  LoginViewController.swift
//  Project
//
//  Created by Alexander Rinne on 06-06-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FacebookCore

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    

    
    @IBOutlet var logInWithFacebookButton: Button!
    @IBOutlet var userNameTextField: Textfield!
    @IBOutlet var passwordTextField: Textfield!
    
    @IBAction func logInWithFacebookButtonTouched(_ sender: Any) {
        print("check4")
        self.performSegue(withIdentifier: "loginToMyPlaces", sender: nil)
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let loginButton = FBSDKLoginButton()
        loginButton.delegate = self
        
//        loginButton.delegate = self
//            as! FBSDKLoginButtonDelegate
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(loginButton)
        
        
        
        let horizontalConstraint = NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.centerX, relatedBy: NSLayoutRelation.equal, toItem: passwordTextField, attribute: NSLayoutAttribute.centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: passwordTextField, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 40)
        let widthConstraint = NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 185)
        let heightConstraint = NSLayoutConstraint(item: loginButton, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 25)
        
        view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        
        if (FBSDKAccessToken.current() != nil)
        {
            print("check7")
            performSegue(withIdentifier: "loginToMyPlaces", sender: nil)
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if let error = error {
            print(error.localizedDescription)
            return
        } else {
            print("user logged in")
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            print(credential)
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    print("could not authenticate user error: \(error)")
                    return
                }
                // User is signed in
                print("user authenticated in to firebase")
                self.performSegue(withIdentifier: "loginToMyPlaces", sender: nil)
                
            }
        }

        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }

    func loginButtonTouched(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError?) {
        print("check5")
        if let error = error {
            print(error.localizedDescription)
            return
        } else {
            let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            Auth.auth().signIn(with: credential) { (user, error) in
                if let error = error {
                    print("could not authenticate user error: \(error)")
                    return
                }
                // User is signed in
                print("user signed in")
                 self.performSegue(withIdentifier: "loginToMyPlaces", sender: nil)
                
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if (FBSDKAccessToken.current() != nil)
        {
            print("check3")
            self.performSegue(withIdentifier: "loginToMyPlaces", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

