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

class CreatePlaceViewController: UIViewController {
    
    let placeTableRef = Database.database().reference(withPath: "placesTable")
    let userTableRef = Database.database().reference(withPath: "usersTable")
    
    var placeID : String = ""
    var facebookID : String = ""
    var placeName : String = ""

    
    
    @IBOutlet var placeImageView: UIImageView!
    @IBOutlet var placeNameLabel: UILabel!
    @IBOutlet var addEventNameTextField: Textfield!
    @IBOutlet var addTimeTextField: Textfield!
    @IBOutlet var addDescriptionTextView: TextView!
    @IBOutlet var createPlaceButton: UIBarButtonItem!
    @IBOutlet var signOutButton: UIBarButtonItem!
    @IBOutlet var addButton: UIView!
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
        
        print("check50")
        let placeItem = PlaceItem(placeID: self.placeID, facebookID: self.facebookID, placeName: self.placeName, eventName: addEventNameTextField.text!, placeTime: addTimeTextField.text!, placeDescription: addDescriptionTextView.text!)
        print("check501")
        print(placeItem)
        
        //              Create a reference to the database for the place
        let placeItemRef = placeTableRef.child(placeID)
        placeItemRef.setValue(placeItem.toAnyObject())
        
        placeTableRef.child("\(placeID)/joiningUsers/\(facebookID)").setValue(["facebookID": facebookID])
        
        self.performSegue(withIdentifier: "createPlaceToMyPlaces", sender: nil)
        

        print("check503")
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("check68")

        if (segue.identifier == "createPlaceToMyPlaces") {
            let viewController = segue.destination as! MyPlacesViewController

            viewController.facebookID = self.facebookID
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.facebookID = Facebook.sharedInstance.facebookID
        print("check59")
        print(facebookID)
        print(placeID)
        print(placeName)
        
        DownloadPicture.sharedInstance.loadFirstPhotoForPlace(placeID: placeID, imageView: self.placeImageView)

        print(facebookID)
        addEventNameTextField.text = ""
        addTimeTextField.text = ""
        addDescriptionTextView.text = ""

        // Do any additional setup after loading the view.
        self.placeNameLabel.text = self.placeName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
