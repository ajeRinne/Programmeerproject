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
            //            Authenticate user and log out
//            try Auth.auth().signOut()

            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            dismiss(animated: true, completion: nil)
            
        } catch {
            print("Could not sign out: \(error)")
        }
    }

    @IBAction func addButtonTouched(_ sender: Any) {
        
        print("check22")
        let placeItem = PlaceItem(placeID: self.placeID, facebookID: self.facebookID, placeName: self.placeName, eventName: addEventNameTextField.text!, placeTime: addTimeTextField.text!, placeDescription: addDescriptionTextView.text!, joiningUsers: facebookID)
        print("check23")
        print(placeItem)
        
        //              Create a reference to the database for the place
        let placeItemRef = placeTableRef.child(placeID)
        placeItemRef.setValue(placeItem.toAnyObject())
        self.performSegue(withIdentifier: "createPlaceToMyPlaces", sender: nil)
        
        print("check24")
//        print(placeItemRef)
    
        
    }
    
   
    
    func loadImageForMetadata(photoMetadata: GMSPlacePhotoMetadata) {
        GMSPlacesClient.shared().loadPlacePhoto(photoMetadata, callback: {
            (photo, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                print("check17")
                print(photo)
                self.placeImageView.image = photo;
                
            }
        })
    }
    
    func loadFirstPhotoForPlace(placeID: String) {
        GMSPlacesClient.shared().lookUpPhotos(forPlaceID: placeID) { (photos, error) -> Void in
            if let error = error {
                // TODO: handle the error.
                print("Error: \(error.localizedDescription)")
            } else {
                print("check18")
                print(placeID)
                print(self.placeName)
                if let firstPhoto = photos?.results.first {
                    print("check19")
                    self.loadImageForMetadata(photoMetadata: firstPhoto)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        print("check41")
        //        _ = sender as! UITableViewCell
        if (segue.identifier == "createPlaceToMyPlaces") {
            let viewController = segue.destination as! MyPlacesViewController

            viewController.facebookID = self.facebookID
            
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("check52")
        print(facebookID)
        print(placeID)
        print(placeName)
        
        
        if (FBSDKAccessToken.current() != nil)
        {
            print("user signed in")
        }else {
            print("no user signed in")
        }

        let user = Auth.auth().currentUser
        loadFirstPhotoForPlace(placeID: placeID)
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
