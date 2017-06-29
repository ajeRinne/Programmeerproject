//
//  CreatePlaceViewController.swift
//  Project
//
//  Created by Alexander Rinne on 08-06-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FacebookLogin
import FacebookCore
import GooglePlaces

class CreatePlaceViewController: UIViewController, UITextViewDelegate {
    
//    MARK: - Constants
    
    let placeTableRef = Database.database().reference(withPath: "placesTable")
    let userTableRef = Database.database().reference(withPath: "usersTable")
    
//    MARK: - Variables
    
    var placeID : String = ""
    var facebookID : String = ""
    var placeName : String = ""

//    MARK: - Outlets
    
    @IBOutlet var placeImageView: UIImageView!
    @IBOutlet var placeNameLabel: UILabel!
    @IBOutlet var addEventNameTextField: Textfield!
    @IBOutlet var addTimeTextField: Textfield!
    @IBOutlet var addDescriptionTextView: TextView!
    @IBOutlet var createPlaceButton: UIBarButtonItem!
    @IBOutlet var signOutButton: UIBarButtonItem!
    @IBOutlet var addButton: UIView!
    
//    MARK: - Actions
    
    @IBAction func signOutButtonTouched(_ sender: Any) {
        do {

            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            dismiss(animated: true, completion: nil)
            
        } catch {
            print("Could not sign out: \(error)")
        }
    }

    @IBAction func addButtonTouched(_ sender: Any) {
        
//        Create place instance
        let placeItem = PlaceItem(placeID: self.placeID, facebookID: self.facebookID, placeName: self.placeName, eventName: addEventNameTextField.text!, placeTime: addTimeTextField.text!, placeDescription: addDescriptionTextView.text!)

//        insert instance in database
        let placeItemRef = placeTableRef.child(placeID)
        placeItemRef.setValue(placeItem.toAnyObject())
        
//        insert user as joiningUser
        placeTableRef.child("\(placeID)/joiningUsers/\(facebookID)").setValue(["facebookID": facebookID])
        
        self.performSegue(withIdentifier: "createPlaceToMyPlaces", sender: nil)
    }
    
//    MARK: - ViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        authenticate user
        self.facebookID = Facebook.sharedInstance.facebookID
        
//        setup keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
//        textview placeholders
        addDescriptionTextView.delegate = self as UITextViewDelegate
        addDescriptionTextView.text = "Describe what you want to do"
        addDescriptionTextView.textColor = UIColor.lightGray
        
//        download place picture
        DownloadPicture.sharedInstance.loadFirstPhotoForPlace(placeID: placeID, imageView: self.placeImageView)
        
        self.placeNameLabel.text = self.placeName
    }
    
//    MARK: - TextView and keyboard
    
//    make placeHolder disapear when tabbed
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if addDescriptionTextView.textColor == UIColor.lightGray {
            addDescriptionTextView.text = nil
            addDescriptionTextView.textColor = UIColor.black
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
